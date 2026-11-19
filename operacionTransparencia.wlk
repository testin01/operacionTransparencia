// operacionTransparencia.wlk

// Punto 1
class Causa {
    var costoBase
    const property caratula
    const property jueces = #{}

    method perjuicioEconomico() = costoBase + self.costoExtra()
    method costoExtra()

    method aumentarCostoBase(monto) {
        costoBase = costoBase + monto
    }
    
    method tieneJuez(juecesAmigos) = juecesAmigos.any({amigo => jueces.any(amigo)})

    method trambolika() = self.perjuicioEconomico() > 5
}

class CausaCompleja inherits Causa {
    const causas = []

    override method costoExtra() = causas.sum({causa => causa.costoExtra()})
}

class CausaSoborno inherits Causa {
    var hayArrepentidos

    override method costoExtra() = if(hayArrepentidos) 1 else 2

    method arrepentirse() { hayArrepentidos = true }
    method hacerseElGil() { hayArrepentidos = false }
}

class CausaObraPublica inherits Causa(costoBase = 3) {
    override method costoExtra() = if(self.cantidadDeJueces() <= 2) 2 else 0
    method cantidadDeJueces() = self.jueces().size()
}


// Punto 2
class Funcionario {
    var property puesto
    const property patrimonioActual
    const causas = []
    const propuestas = []

    method asignarCausa(causa) {
        if (!self.validarPatrimonio()) {
            throw new DomainException(message = "El funcionario debe tener un patrimonio positivo")
        }

        if(!puesto.validarReglas(self, causa)){
            throw new DomainException(message = puesto.mensajeDeRechazo())
        }

        causas.add(causa)
    }

    method validarPatrimonio() = patrimonioActual > 0
    method modificarPuesto(puestoNuevo) { puesto = puestoNuevo}

    // Punto 3
    method causasQueLoDejanPegado() = causas.filter({ causa => causa.trambolika() })

    method saleEnMedios() {
      causas.forEach({ causa => causa.aumentarCostoBase(0.1) })
    }
    
    method aceptaPropuesta(propuesta) {
        if(!puesto.leGusta(propuesta)) propuesta.postergar()
        propuestas.add(propuesta)
    }
/*     method escucharPropuesta(propuesta){
        const fechaPrometida = if (puesto.aceptaTalCual(propuesta))
            propuesta.fechaCumplimiento()
        else
            propuesta.fechaPresentacion().plusYears(4)

        return new Promesa(
            descripcion = propuesta.descripcion(),
            fechaCumplimiento = fechaPrometida
        )

        propuestas.add(propuesta)
    } */
}

class Ejecutivo{ // No todos tienen los mismos amigos
    const palabrasClave = ["aumento", "impuestos", "inflacion"]
    const jueces = #{}
    method validarReglas(causa) = causa.tieneJuez(jueces)

    method mensajeDeRechazo() = "No tiene un juez amigo en la causa"
    method aceptaTalCual(propuesta) = propuesta.contienePalabra(palabrasClave)

    method leGusta(propuesta) = palabrasClave.any{palabra => propuesta.contieneDescripcion(palabra)}
}
object ministro { // Entre ministros son iguales
    method validarReglas(funcionario, causa) = funcionario.patrimonioActual() > (0.50 * causa.perjuicioEconomico())
    method mensajeDeRechazo() = "No tiene un patrimonio mayor al 50% del perjuicio de la causa"

    method aceptaTalCual(propuesta) = propuesta.duraMenosDeUnAno()
}

class Propuesta {
    var descripcion
    var fechaCumplimiento
    var fechaPresentacion

    method postergar() {
        fechaCumplimiento = fechaCumplimiento.plusYears(4)
    }
    method duraMenosDeUnAno() = fechaCumplimiento < fechaPresentacion.plusYears(1)
    method contienePalabra(palabras) = palabras.any({ palabra => descripcion.contains(palabra)})
}
/*
class Promesa {
    const property descripcion
    const property fechaCumplimiento
} */