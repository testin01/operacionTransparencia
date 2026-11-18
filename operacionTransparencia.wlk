// operacionTransparencia.wlk
class Causa {
    var property costoBase
    const property caratula
    const property jueces = []

    method calcularPerjuicioEconomico() = self.costoBase() + self.costoExtra()
    method costoExtra()
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
}

object ejecutivo{
    method validarReglas(funcionario, causa) = causa.jueces().any({juez => funcionario.esAmigoDe(juez)})

    method mensajeDeRechazo() = "No tiene un juez amigo en la causa"
}
object ministro {
    method validarReglas(funcionario, causa) = funcionario.patrimonioActual() > (0.50 * causa.calcularPerjuicioEconomico())
    method mensajeDeRechazo() = "No tiene un patrimonio mayor al 50% del perjuicio de la causa"
}