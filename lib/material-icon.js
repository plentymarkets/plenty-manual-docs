function materialIcon() {
    this.process((parent, target, attrs) => {
        const icon = target;
        const iconColour = attrs.role || '';
        const theIcon = `<span class="icon ${iconColour}"><i class="material-icons">${icon}</i></span>`;

        return this.createInline(parent, 'quoted', theIcon).convert()
    })
}

function register(registry) {
    registry.inlineMacro('material', materialIcon)
}

module.exports.register = register