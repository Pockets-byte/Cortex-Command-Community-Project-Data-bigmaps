function Create(self)
	local painSoundPitch = self.PainSound and self.PainSound.Pitch or 1;
	local deathSoundPitch = self.DeathSound and self.DeathSound.Pitch or 1;
	
	if (math.random() >= 0.5) then
		self.PainSound = CreateSoundContainer("Human Pain", "Base.rte");
		self.DeathSound = CreateSoundContainer("Human Death", "Base.rte");
	else
		self.PainSound = CreateSoundContainer("Human Pain Alt", "Base.rte");
		self.DeathSound = CreateSoundContainer("Human Death Alt", "Base.rte");
	end
	if (math.random() < 0.02) then
		self.PainSound = CreateSoundContainer("Human Pain Steve", "Base.rte");
	end
	
	self.PainSound.Pitch = painSoundPitch;
	self.DeathSound.Pitch = deathSoundPitch;
end