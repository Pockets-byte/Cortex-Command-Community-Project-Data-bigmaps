function Create(self)
	self.pullTimer = Timer();

	self.loaded = false;
	self.rotFactor = math.pi;
	
	self.setAngle = 0;
	self.tilt = 0.5/math.sqrt(self.Radius);
end
function Update(self)
	local parent;
	local actor = self:GetRootParent();
	if actor and IsAHuman(actor) then
		parent = ToAHuman(actor);
	end
	if self.setAngle > 0 then
		self.setAngle = self.setAngle - (0.001 * (10 + math.sqrt(self.RateOfFire) * self.setAngle));
		if self.setAngle < 0 then
			self.setAngle = 0;
		end
	end
	if self.FiredFrame then
		self.shell = CreateMOSParticle("Casing Long");
		self.loaded = false;
		self.playedSound = false;
		self.rotFactor = math.pi;
		self.setAngle = self.setAngle + self.tilt;
	end
	self.RotAngle = self.RotAngle + (self.setAngle * self.FlipFactor);
	local jointOffset = Vector(self.JointOffset.X * self.FlipFactor, self.JointOffset.Y):RadRotate(self.RotAngle);
	self.Pos = self.Pos - jointOffset + Vector(jointOffset.X, jointOffset.Y):RadRotate(-self.setAngle * self.FlipFactor);
	if parent and not self.loaded and self.RoundInMagCount > 0 and not self.reloadCycle then
		self:Deactivate();
		if self.pullTimer:IsPastSimMS(15000/self.RateOfFire) then
			if not self.playedSound then
				AudioMan:PlaySound("Ronin.rte/Devices/Weapons/K98K/Sounds/Chamber.wav", self.Pos);
				self.playedSound = true;
			end
			if self.shell then
				self.shell.Pos = self.Pos;
				self.shell.Vel = self.Vel + Vector(-6 * self.FlipFactor, -4):RadRotate(self.RotAngle);
				self.shell.Team = self.Team;
				MovableMan:AddParticle(self.shell);
				self.shell = nil;
			end
			--Animate the gun to signify the bolt being pulled
			local balance = 5 + math.abs(math.sin(actor.RotAngle) * 5);	--Laying down horizontally reduces swaying when pulling bolt
			self.Frame = 1;
			self.SupportOffset = Vector(-5, -1);
			local rotTotal = math.sin(self.rotFactor)/balance;
			self.RotAngle = self.RotAngle + (self.FlipFactor * rotTotal);
			self.Pos = self.Pos - jointOffset + Vector(jointOffset.X, jointOffset.Y):RadRotate(-rotTotal * self.FlipFactor);
			self.rotFactor = self.rotFactor - (math.pi * 0.0005 * self.RateOfFire);
		end
		if self.rotFactor <= 0 then
			self.loaded = true;
			self.Frame = 0;
			self.SupportOffset = Vector(0.1, 4);
			self.rotFactor = 0;
		end
	else
		self.pullTimer:Reset();
	end
end