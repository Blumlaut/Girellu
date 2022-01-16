local _l_brightness_filter = ac.ColorCorrectionHsb { hue=0, saturation=1.0, brightness=1.0, keepLuminance=true }
ac.weatherColorCorrections[#ac.weatherColorCorrections + 1] = _l_brightness_filter

function init_pure_script()
	__SCRIPT__setVersion(7.4)
	__SCRIPT__UI_SliderFloat("Contrast Day", 0.975, 0.96, 1.0)
	__SCRIPT__UI_SliderFloat("Gamma Day", 1.33, 1, 1.6)
	ac.setPpTonemapFunction(5)
end

function update_pure_script(dt)
	contrast_day = __SCRIPT__UI_getValue("Contrast Day")
	gamma_day = __SCRIPT__UI_getValue("Gamma Day")
	exp = PURE__return_IDLE_EXPOSURE()
	ac.setPpTonemapExposure(exp)
	--ac.setPpContrast(1 - ((1-contrast_day) * from_twilight_compensate(0)))
	--ac.setPpContrast(1 - ((1-contrast_day) * sun_compensate(0)))
	ac.setPpContrast(1 - ((1-contrast_day) * day_compensate(0)))
	ac.setPpTonemapGamma(1 + (gamma_day - 1	) * from_twilight_compensate(0))	
	PURE__set_PP_Tonemapping_Curve(1)
	ac.setGlareBloomLuminanceGamma(0.85 + (0.75 * from_twilight_compensate(0)))
	local ref_point = 1 / exp * day_compensate(0.65)
	ac.setWhiteReferencePoint(ref_point)
	ac.debug("contrast", string.format('%.3f', ac.getPpContrast()))
	ac.debug("gamma", string.format('%.3f', ac.getPpTonemapGamma()))
	_l_brightness_filter.brightness = 1.05 - (0.9 * exp)
end