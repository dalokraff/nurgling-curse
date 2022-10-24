return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`nurgling-curse` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("nurgling-curse", {
			mod_script       = "scripts/mods/nurgling-curse/nurgling-curse",
			mod_data         = "scripts/mods/nurgling-curse/nurgling-curse_data",
			mod_localization = "scripts/mods/nurgling-curse/nurgling-curse_localization",
		})
	end,
	packages = {
		"resource_packages/nurgling-curse/nurgling-curse",
	},
}
