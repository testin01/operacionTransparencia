// operacionTransparencia.wlk

// Punto 1
class Causa {
    var property costoBase
    const property caratula
    const property jueces = []

    method calcularPerjuicioEconomico() = self.costoBase() + self.costoExtra()
    method costoExtra()

    method aumentarCostoBase(monto) {
        costoBase = costoBase + monto
    }
}

class CausaCompleja inherits Causa {
    const causas = []

    override method costoExtra() = causas.sum({causa => causa.costoExtra()})
}

class CausaSoborno inherits Causa {
    const hayArrepentidos

    override method costoExtra() = if(hayArrepentidos) 1 else 2
}

object tribunalDeObraPublica {
    method jueces() = ["Dr. Rodolfo Kometa", "Dr. Armando U. Nacausa"] // casos de ejemplo
}

class CausaObraPublica inherits Causa(costoBase = 3) {
    override method costoExtra() = if(self.cantidadDeJueces() <= 2) 2 else 0
    override method jueces() = tribunalDeObraPublica.jueces()
    method cantidadDeJueces() = self.jueces().size()
}


// Punto 2
class UserException inherits Exception{}

class Funcionario {
    var puesto
    const property patrimonioActual
    const juecesAmigos = []
    const causas = []

    method asignarCausa(causa) {
        if (!self.validarPatrimonio()) {
            throw new UserException(message = "El funcionario debe tener un patrimonio positivo")
        }

        if(!puesto.validarReglas(self, causa)){
            throw new UserException(message = puesto.mensajeDeRechazo())
        }

        causas.add(causa)
    }

    method validarPatrimonio() = patrimonioActual > 0
    method esAmigoDe(juez) = juecesAmigos.contains(juez)
    method modificarPuesto(puestoNuevo) { puesto = puestoNuevo}

    // Punto 3
    method causasQueLoDejanPegado() = causas.filter({ causa => self.loDejaPegado(causa)})
    method loDejaPegado(causa) = self.tienePerjuicioTramboliko(causa)
    method tienePerjuicioTramboliko(causa) = causa.calcularPerjuicioEconomico() > 5

    method saleEnMedios() {
      causas.forEach({ causa => causa.aumentarCostoBase(0.1) })
    }
    
    method escucharPropuesta(propuesta){
        const fechaPrometida = if (puesto.aceptaTalCual(propuesta))
            propuesta.fechaCumplimiento()
        else
            propuesta.fechaPresentacion().plusYears(4)

        return new Promesa(
            descripcion = propuesta.descripcion(),
            fechaCumplimiento = fechaPrometida
        )
    }
}

object ejecutivo{
    const palabrasClave = ["aumento", "impuestos", "inflacion"]
    method validarReglas(funcionario, causa) = causa.jueces().any({juez => funcionario.esAmigoDe(juez)})

    method mensajeDeRechazo() = "No tiene un juez amigo en la causa"
    method aceptaTalCual(propuesta) = propuesta.contienePalabra(palabrasClave)
}
object ministro {
    method validarReglas(funcionario, causa) = funcionario.patrimonioActual() > (0.50 * causa.calcularPerjuicioEconomico())
    method mensajeDeRechazo() = "No tiene un patrimonio mayor al 50% del perjuicio de la causa"

    method aceptaTalCual(propuesta) = propuesta.duraMenosDeUnAno()
}

class Propuesta {
    const property descripcion
    const property fechaCumplimiento
    const property fechaPresentacion

    method duraMenosDeUnAno() = self.fechaCumplimiento() < self.fechaPresentacion().plusYears(1)
    method contienePalabra(palabras) = palabras.any({ palabra => self.descripcion().contains(palabra)})
}

class Promesa {
    const property descripcion
    const property fechaCumplimiento
}