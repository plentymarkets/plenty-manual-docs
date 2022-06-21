function terraIcon () {
    this.process((parent, target, attrs) => {
        const icon = target;
        const iconColour = attrs.role || '';
        const theIcon = `<span class="icon ${iconColour}"><i class="psicon-${icon}"></i></span>`;

        return this.createInline(parent, 'quoted', theIcon ).convert()
    })
}

function register (registry) {
    registry.inlineMacro('terra', terraIcon)
  }
  
  module.exports.register = register