Reto4
=====

Integrantes
-----------

* Daniel Múnera Sánchez
* Ernesto Javier Quintero


Esta aplicación esta compuesta de 2 aplicaciones que tienen como requerimiento general.

**RUBY 1.9.2**


Aplicaciones
============


Aplicación web
--------------

La aplicacion web fue realizada utilizando el framework web Rails y las siguientes gemas(Librerias):

* rails -v 3.1.3
* jquery-rails
* private_pub
* thin
* omniauth-twitter
* omniauth-facebook
* cancan
* sqlite3

Aplicación cliente grueso
-------------------------

Aplicación de escritorio, que es un cliente capaz de contectarse con la aplicación web y consumir los servicios
que esta presta. Las librerias(gemas) utilizadas fueron:

* net/http
* hpricot
* json
* digest/md5
* yaml
* highline/import
* thread

Despliegue de las aplicaciónes
==============================

**Aplicación web**
--------------

Ingresar a la carpeta webapp y ejecutar para instalar todos los requerimientos. 

```bash
bundle install 
```

Para correr la aplicación y en caso de haber un problema lo repotara.

Luego ejecutar el comando para crear la base de datos:

```bash
rake db:migrate
```
	

	
Finalmente ejecute el siguiente comando para iniciar el servidor:

```bash
rails s
```

Y desde su navegador vaya a la direccion **http://localhost:3000** 

debe iniciar el servidor de la aplicacion para el websocket

```bash
bundle exec rackup private_pub.ru -s thin -p 8000 -E production
```

**Aplicación cliente grueso**
-------------------------

**COMO EJECUTAR**

**NOTA** : La aplicación cliente solo funciona en el momento para usuarios locales, no hay logueo con Twitter o Facebook desde el cliente

Dirigirse al directorio donde se encuentra el archivo **startChat.rb** y ejecutar el comando:

```bash
 ruby startChat.rb **nickname-local-user** ,  **Example** ruby startClient.rb admin
```bash

**COMANDOS DISPONIBLES**

* canal: <nombre del canal> ~> Comando utilizado despues de loguearse para seleccionar el canal que se va a usar para chatear.
* enviar: <msg>  ~> Comando utilizado para enviar un mensaje al canal.
* enviar: <msg> => <username> ~> Comando utilizado para enviar un mensaje privado a un usuario de un canal.
* quit ~> Comando para salir de la aplicacion.










