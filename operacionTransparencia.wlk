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