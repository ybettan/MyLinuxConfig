import { Plugin } from "@opencode/plugin/tui"

// Set by the opencode / opencode-enmaas shell wrappers in dotfiles/bashrc.
const profile = process.env.OPENCODE_PROFILE_NAME?.trim()

export default Plugin.define({
  id: "ybettan.profile",
  setup(context) {
    if (!profile) return

    // Show the active profile next to the prompt footer status indicators so
    // it stays visible for the whole session.
    return context.ui.slot({
      append: "prompt.footer.status",
      render: () => <text fg={context.theme.text.muted}>[profile: {profile}]</text>,
    })
  },
})
