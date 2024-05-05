# actions/calculadora/calculate.sh
#!/bin/bash

# Argumentos
OPERACION="$1"
VALORES_RAW="$2"

# Validar
if [[ "$OPERACION" != "suma" && "$OPERACION" != "resta" && "$OPERACION" != "multiplicacion" && "$OPERACION" != "division" ]];
  echo "Operacion invalida. Use suma, resta, multiplicacion o division."
  exit 1
fi

# Convertir valores a un array
IFS=',' read -r -a VALORES <<< "$VALORES_RAW"

# Validar
if [[ ${#VALORES[@]} -lt 2 ]];
  echo "Se requieren al menos 2 valores para la operacion."
  exit 1
fi

# Inicializar resultado con el primer valor
RESULTADO=${VALORES[0]}

# Ejecutar operacion
for (( i = 1; i < ${#VALORES[@]}; i++ )); do
  case "$OPERACION" en
    suma)
      RESULTADO=$(echo "$RESULTADO + ${VALORES[$i]}" | bc)
      ;;
    resta)
      RESULTADO=$(echo "$RESULTADO - ${VALORES[$i]}" | bc)
      ;;
    multiplicacion)
      RESULTADO=$(echo "$RESULTADO * ${VALORES[$i]}" | bc)
      ;;
    division)
      if [[ ${VALORES[$i]} -eq 0 ]];
        echo "Error: No se puede dividir por cero."
        exit 1
      fi
      RESULTADO=$(echo "$RESULTADO / ${VALORES[$i]}" | bc -l)
      ;;
  esac
done

# Establecer salida para GitHub Actions
echo "resultado=$RESULTADO" >> $GITHUB_ENV
