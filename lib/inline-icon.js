function inlineIcon () {
  this.process((parent, target, attrs) => {
    const icon = target;
    let iconColour = '';
    let iconSet = 'fa fa-';

    if (attrs.set !== 'undefined') {
        if (attrs.set === 'plenty') {
            iconSet = 'psicon-';
        }
        else if (attrs.set === 'material') {
            iconSet = 'material-';
        }
    }

    if (typeof attrs.role !== 'undefined' && attrs.role) {
        iconColour = ' ' + attrs.role;
    }

    if (attrs.set !== 'undefined' && attrs.set === "plenty") {
        let icon = '';
        let plentyIconColour = '';
        if (attrs.role) {
            plentyIconColour = attrs.role;
        }
        icon = `<span class="icon ${plentyIconColour}"><i class="psicon-${icon}"></i></span>`;
        return icon;
    }

    if ( attrs.type === "icon" ) {
        const primaryIcon = target;
        let icon = '';
        let primaryIconColour = '';
        let rotationIconClass = '';
        let flipIconClass = '';

        if (attrs.role)
            primaryIconColour = attrs.role;

        if (attrs.rotate) {
            const rotationDegrees = attrs.rotate;
            rotationIconClass = `fa-rotate-${rotationDegrees}`;
        }

        if (attrs.flip) {
            const flipDirection = attrs.flip;
            flipIconClass = `fa-flip-${flipDirection}`;
        }

        if (attrs.stack) {
            const stackClass = 'fa-stack fa-lg';
            const stackLargeIconClass = 'fa-stack-2x';
            const stackSmallIconClass = 'fa-stack-1x';
            const stack = node.getAttribute("stack");;

            let stackedIcon = '';
            let stackedIconColour = 'black';
            let stackedIconPosition = '';

            stackedIcon = stack.slice(0, stack.indexOf(','));

            if (((stack.match(/,/g)) || []).length > 1) {
                stackedIconPosition = stack.slice(stack.indexOf(',') + 1, stack.lastIndexOf(','));
                stackedIconColour = stack.slice(stack.lastIndexOf(',') + 1);
            }
            else {
                stackedIconPosition = stack.slice(stack.indexOf(',') + 1);
            }

            icon = `<span class="icon ${primaryIconColour} ${stackClass}"><i class="fa fa-${primaryIcon} ${stackLargeIconClass} ${rotationIconClass} ${flipIconClass}"></i><span class="icon ${stackedIconColour}"><i class="fa fa-${stackedIcon} ${stackSmallIconClass} ${stackedIconPosition}"></i></span></span>`;
            return icon;
        }

        icon = `<span class="icon ${primaryIconColour}"><i class="fa fa-${primaryIcon} ${rotationIconClass} ${flipIconClass}"></i></span>`;
        return icon;
    }
    text = `<span class = 'icon${iconColour}'><i class = ${iconSet}${icon}'</i></span>`;
    return text;
  })
}

function register (registry) {
  registry.block('icon', inlineIcon)
}

module.exports.register = register