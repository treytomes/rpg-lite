// Load a module into a local variable, allowing it to be reassigned at will.
// e.g. player = import("playerBehaviors")
globals.require = function(moduleName)
	import moduleName
	return locals[moduleName]
end function
