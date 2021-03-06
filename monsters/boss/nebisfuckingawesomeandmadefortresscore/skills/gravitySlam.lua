--------------------------------------------------------------------------------
gravitySlam = {}

function gravitySlam.enter()
  if not hasTarget() then return nil end
  
  self.increaseGravity = false
  self.sounded = false
  self.worldGravity = world.gravity(mcontroller.position())
  self.originalWorldGravity = self.worldGravity

  return {
    heavyGravityDuration = config.getParameter("heavyGravityDuration", 2),
    zeroGravityDuration = config.getParameter("zeroGravityDuration", 2)
  }
end

function gravitySlam.enteringState(stateData)
  monster.setActiveSkillName("gravitySlam")
  animator.playSound("alert")
end

function gravitySlam.update(dt, stateData)
  if not hasTarget() then return true end
 
  if stateData.zeroGravityDuration > 0 then
    stateData.zeroGravityDuration = stateData.zeroGravityDuration - dt
		world.setDungeonGravity(0, -(self.worldGravity/10))
		world.setDungeonBreathable(0, false)

	if stateData.zeroGravityDuration <= 0.15 and not self.sounded then
    animator.playSound("alert")
	  self.sounded = true
	end
    if stateData.zeroGravityDuration <= 0 then
	  self.increaseGravity = true
    end
  end
  
  if self.increaseGravity and stateData.heavyGravityDuration > 0 then
    stateData.heavyGravityDuration = stateData.heavyGravityDuration - dt
  
		world.setDungeonGravity(0, (self.worldGravity/2))
	
	if stateData.heavyGravityDuration <= 0 then
    return true
		end
  end

  return false
end

function gravitySlam.leavingState(stateData)
  self.increaseGravity = false
  self.sounded = false
  world.setDungeonGravity(0, self.originalWorldGravity)
  world.setDungeonBreathable(0, true)
end
