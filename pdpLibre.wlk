class Producto{
    const nombre
    var property precioBase

    method precio() = precioBase * 1.21

     method nombreEnOferta(){
    return "SUPER OFERTA " + nombre
  }


}

class Mueble inherits Producto{

    override method precio() = super() + 1000
    
}

class Indumentaria inherits Producto{
    var property esDeTemporadaActual = true

    override method precio(){
        if(esDeTemporadaActual){
            return super() * 1.1
        }
        else{
            return super()
        }
    }
}

class Ganga inherits Producto{
    override method precio () = 0

    override method nombreEnOferta(){
        return super() + " COMPRAME POR FAVOR"
    }
}

class Cupon {
    var usado = false 
    const descuento 

    method descuento() = descuento

    method usar(){
        usado = true 
    }
}

//usuarios
class Usuarios {
    const nombre
    var cupones = []
    var carrito = []
    var productosComprados = []
    var dineroDisponible 
    var puntos 
    var nivel = bronce

    method modificarPuntos(nuevospuntos){
        puntos += nuevospuntos
    }

    method recibirCupon(unCupon) = cupones.add(unCupon)

    method agregarAlcarrito(unProducto){
        administracion.nivelDelUsuario(self)
        if(nivel.espacioDisponible(carrito)){
            carrito.add(unProducto)
        }else{
            throw new Exception(message = "¡No hay espacio disponible en el carrito")
        }
    } 

    method pagar(valorDeLaCompra){
        dineroDisponible -= valorDeLaCompra
    }


    method comprarUsandoDescuento(){
        self.pagar(administracion.precioCarritoConDescuento(self))
        self.modificarPuntos(administracion.precioCarritoConDescuento(self)*0.10)
        productosComprados ++ carrito 
        carrito = []
    }

}

object administracion{
    method nivelDelUsuario(unUsuario){
        if(self.condicionDelNivel(bronce, unUsuario.puntos())){
            unUsuario.nivel(bronce)
        }
        if(self.condicionDelNivel(plata, unUsuario.puntos())){
            unUsuario.nivel(plata)
        }
        else{
            unUsuario.nivel(oro)
        }
    }
    method condicionDelNivel(nivel, puntos) = nivel.condicionPuntos(puntos)
   
    method precioTotalDelCarrito(unUsuario) = unUsuario.carrito().sum({producto => producto.precio()})
    
    method precioCarritoConDescuento(unUsuario) = self.precioTotalDelCarrito(unUsuario) - self.usarDescuentoDeUnCupon(unUsuario) * self.precioTotalDelCarrito(unUsuario)
    
    method usarDescuentoDeUnCupon(unUsuario){
        if(unUsuario.cupones().length() == 0){
            throw new Exception(message = "El usuario no tiene cupones")
        }
        else{
            const unCupon = unUsuario.cupones().anyOne()
            unCupon.usar(true)
            unUsuario.cupones().remove(unCupon)
            return unCupon.descuento()
        }
       
    }

    method esMoroso(unUsuario) = unUsuario.dineroDisponible() < 0
    
    method usuariosMorosos(usuarios) = usuarios.filter({usuario => usuario.esMoroso()})

    method penalizarMorosos(usuarios){
        self.usuariosMorosos(usuarios).forEach({usuario => usuario.modificarPuntos(- 1000)})
    }


}


object bronce {
    method condicionPuntos(puntos) = puntos < 5000
    method espacioDisponible(carrito) = carrito.length() < 1
}

object plata{
    method condicionPuntos(puntos) = puntos >= 5000 && puntos < 15000
    method espacioDisponible(carrito) = carrito.length() < 5
}

object oro{
    method condicionPuntos(puntos) = puntos >= 15000
    method espacioDisponible(carrito) = true
 
}
