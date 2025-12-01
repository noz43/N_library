N = N or {}
N.Library = N.Library or {}
N.Library.Version = "1.0.0"

local base = "n_library/"

include(base .. "core/sh_config.lua")
include(base .. "core/sh_theme.lua")
include(base .. "core/cl_fonts.lua")
include(base .. "core/cl_materials.lua")

include(base .. "utils/cl_patterns.lua")
include(base .. "utils/cl_imgur.lua")
pcall(include, base .. "utils/cl_draw.lua")
pcall(include, base .. "utils/cl_animations.lua")
pcall(include, base .. "utils/cl_helpers.lua")
include(base .. "utils/cl_draw_advanced.lua")  

include(base .. "components/base/cl_base_panel.lua")

include(base .. "components/containers/cl_frame.lua")
include(base .. "components/containers/cl_panel.lua")
include(base .. "components/containers/cl_scrollpanel.lua")
include(base .. "components/containers/cl_sidebar.lua")

include(base .. "components/buttons/cl_button.lua")
include(base .. "components/buttons/cl_icon_button.lua")
pcall(include, base .. "components/buttons/cl_text_button.lua")

include(base .. "components/inputs/cl_textentry.lua")
include(base .. "components/inputs/cl_search.lua")
include(base .. "components/inputs/cl_textarea.lua")

include(base .. "components/forms/cl_checkbox.lua")
include(base .. "components/forms/cl_slider.lua")
include(base .. "components/forms/cl_progress.lua")
include(base .. "components/forms/cl_progresscircular.lua")
include(base .. "components/forms/cl_progresscircular_advanced.lua")
include(base .. "components/forms/cl_progressstepper.lua")



include(base .. "components/cards/cl_card.lua")
include(base .. "components/cards/cl_user_card.lua")
include(base .. "components/cards/cl_info_card.lua")
include(base .. "components/cards/cl_statcard.lua")
include(base .. "components/cards/cl_textimagecard.lua")
include(base .. "components/cards/cl_largeimagecard.lua")

include(base .. "components/lists/cl_dropdown.lua")
include(base .. "components/lists/cl_list.lua")
include(base .. "components/lists/cl_listitem.lua")
include(base .. "components/lists/cl_userlist.lua")
include(base .. "components/lists/cl_missionlist.lua")
include(base .. "components/lists/cl_itemgrid.lua")

pcall(include, base .. "components/modals/cl_modal.lua")
pcall(include, base .. "components/modals/cl_confirm.lua")
pcall(include, base .. "components/modals/cl_query.lua")

include(base .. "components/misc/cl_avatar.lua")
include(base .. "components/misc/cl_badge.lua")
include(base .. "components/misc/cl_divider.lua")

N.Library.Loaded = true
print("[N Library] v" .. N.Library.Version .. " loaded successfully!")

concommand.Add("n_showcase", function()
    if N.CreateShowcase then
        N.CreateShowcase()
    end
end)