import 'package:flutter/material.dart';
import 'package:sindcelma_app/themes.dart';

enum TypeButton {
  elevated,
  text
}

class BtnIconOutline extends StatelessWidget {

  final String value;
  final VoidCallback onPressed;
  final TypeColor colorType;
  final Icon icon;

  const BtnIconOutline(this.colorType, this.value, this.icon,  this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    Color? colorTheme;

    switch(colorType){
      case TypeColor.text:
        colorTheme = SindcelmaTheme.color_text; break;
      case TypeColor.secondary:
        colorTheme = SindcelmaTheme.color_secondary; break;
      case TypeColor.primary:
      default:
        colorTheme = SindcelmaTheme.color_primary; break;
    }

    return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: colorTheme ?? Colors.blue),

        ),
        onPressed: onPressed,
        label: Text(value,
          style: TextStyle(
            fontSize: 20,
            color: colorTheme,
            fontFamily: 'Oswald',
          ),
        ),
        icon: icon,
    );
  }

}

class BtnIcon extends StatelessWidget {

  final String value;
  final VoidCallback onPressed;
  final TypeColor colorType;
  final Icon icon;

  const BtnIcon(this.colorType, this.value, this.icon, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color? colorTheme;

    switch(colorType){
      case TypeColor.text:
        colorTheme = SindcelmaTheme.color_text; break;
      case TypeColor.secondary:
        colorTheme = SindcelmaTheme.color_secondary; break;
      case TypeColor.primary:
      default:
        colorTheme = SindcelmaTheme.color_primary; break;
    }

    return TextButton.icon(
        onPressed: onPressed,
        label: Text(value,
          style: TextStyle(
              fontSize: 20,
              color: colorTheme,
              fontFamily: 'Oswald',
          ),
        ),
        icon: icon
    );
  }
}


class Btn extends StatelessWidget {

  final String value;
  final VoidCallback onPressed;
  final TypeButton type;
  final TypeColor colorType;

  const Btn(this.type, this.colorType, this.value, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color? colorTheme;

    switch(colorType){
      case TypeColor.text:
        colorTheme = SindcelmaTheme.color_text; break;
      case TypeColor.secondary:
        colorTheme = SindcelmaTheme.color_secondary; break;
      case TypeColor.primary:
      default:
        colorTheme = SindcelmaTheme.color_primary; break;
    }

    switch(type){
      case TypeButton.text:
        return TextButton(
            onPressed: onPressed,
            child: Text(value,
              style: TextStyle(
                  color: colorTheme,
                  fontFamily: 'Oswald',
                  fontSize: 18
              ),
            ),
        );
      case TypeButton.elevated:
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorTheme,
            textStyle: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 18
            )
          ),
          child: Text(value),
        );
    }

  }

}
