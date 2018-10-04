/*---Practoca 5----*/

/*
[] 5 SELECT BASICOS CON CAMBIO EN NOMBRE DE COLUMNA, ALIAS Y USO DE FUNCIONES (CONCATENACION, V.*, SUBSTRING)
*/

/********************************Muestra la longitud de los nombres de clientes******************************/
select len(c.Nombre + ' ' + c.ApPat+ ' ' +c.ApMat) as CaracteresNombre
from Cliente as c

/************************************* Muestra la edad del empleado mayor ***********************************/
select Max(e.edad) as Mayor
from Empleado as e

/************************************* Muestra la edad del empleado menor ***********************************/
select Min(e.edad) as Menor
from Empleado as e

/******************************* Muestra la suma de los sueldo que hay qeu pagar *****************************/
select sum(n.SueldoTotal) as Sueldo
from Nomina as n

/******************************* Muestra la suma de las horas totales trabajadas *****************************/
select sum(n.HorasTrabajadas) as HorasTotales
from Nomina as n


/*
[] 4 SELECT JOIN (CROSS, INNER, LEFT, RIGHT)
*/
/**************************** Muestra los sueldos totales de los empleados **************************/
 select e.Nombre, e.apPat,
	   n.sueldoTotal
 from Empleado as e,Nomina as n

 /******************************* Muestra las habitaciones por reservacion *****************************/
select h.idHabitacion,
	   r.idReservacion
 from Habitacion as h
 inner join Reservacion as r
 on r.idHabitacion = h.idHabitacion

/******************************* Muestra los estados de las habitaciones *****************************/
select h.idHabitacion,
	   d.estado
 from Habitacion as h
 left join Disponibilidad as d
 on h.idHabitacion = d.idHabitacion

 /******************************* Muestra los estados de las habitaciones *****************************/
select h.idHabitacion,
	   d.estado
 from Habitacion as h
 right join Disponibilidad as d
 on h.idHabitacion = d.idHabitacion

/*
[] 5 SELECT CON USO DE WHERE EN DIFERENTES TABLAS Y CAMPOS y uno de esos con order by
*/
/******************************* Muestra los empleados de seguridad *****************************/
select (e.Nombre + ' ' + e.ApPat+ ' ' +e.ApMat) as NombreCompleto,
	   d.nombre
 from Empleado as e
 left join Departamento as d on d.idDepartamento = e.idDepartamento
 where d.nombre = 'seguridad'

 /******************************* Muestra las habitaciones disponibles *****************************/
select h.idHabitacion,
	   d.estado
 from Habitacion as h
 left join Disponibilidad as d on d.idHabitacion = h.idHabitacion
 where d.estado = 'disponible'
 order by h.idHabitacion desc

 /************************** Muestra las reservaciones con coste mayoor a 5500 ************************/
select idReservacion , precio
 from Reservacion 
 where precio > 5500

  /******************************* Muestra los empleados mayores a 23 a;os *****************************/
select (Nombre + ' ' + ApPat+ ' ' +ApMat) as NombreCompleto, edad
 from Empleado
 where edad > 23

/************************* Muestra los servicios solicitados por el cliente Pablo ***********************/
 select v.idVenta,
        c.nombre,c.apPat,
        s.*
  from venta as v
  inner join cliente as c on c.idCliente = v.idCliente
  inner join ServiciosVendidos as sv on sv.idVenta = v.idVenta
  inner join Servicio as s on s.idServicio = sv.idServicio
  where c.nombre = 'Pablo'

/*
[] 5 SELECT CON USO DE FUNCIONES DE AGREGACION (MIN, MAX, AVG, STD, COUNT)
	*2 SIN GROUP BY
	*3 CON GROUP BY -> 1 CON HAVING
*/

/************************* Muestra cuanto cuesta el servicio mas caro ***********************/
select max(precio) as 'servicio mas caro'
from Servicio

/************************* Muestra cual es el piso mas alto del hotel ***********************/

select max(piso) as 'piso mas alto'
from Habitacion

/************************* Muestra cuantos empleados tiene cada departamento ***********************/
select COUNT(e.idempleado) as 'numero de empleados', d.nombre
FROM Empleado as e
inner join Departamento as d on d.idDepartamento = e.idDepartamento
group by d.nombre

/************************* Muestra cuantos clientes han pedido cierto servicio ***********************/
 select count(c.idCliente) as 'numero de clientes', s.nombre
  from venta as v
  inner join cliente as c on c.idCliente = v.idCliente
  inner join ServiciosVendidos as sv on sv.idVenta = v.idVenta
  inner join Servicio as s on s.idServicio = sv.idServicio
group by s.nombre


/************************* Muestra los pisos con 2 o mas habitaciones ***********************/
select COUNT(idHabitacion) as 'numero de habitaciones', piso
FROM Habitacion
group by piso
having count(idHabitacion) >= 2
order by count(idHabitacion) asc



/*
[] 3 SELECT CON JOIN Y GROUP BY
*/
/************************* Muestra cuantos clientes tiene cada venta ***********************/
 select count(c.idCliente) as 'numero de clientes', v.idVenta
  from venta as v
  inner join cliente as c on c.idCliente = v.idCliente
group by v.idVenta

/************************* Muestra cuantos servicios se han pedido ***********************/
 select count(c.idCliente) as 'numero de clientes', s.nombre
  from venta as v
  inner join cliente as c on c.idCliente = v.idCliente
  inner join ServiciosVendidos as sv on sv.idVenta = v.idVenta
  inner join Servicio as s on s.idServicio = sv.idServicio
group by s.nombre

/************************* Muestra cuantos empleados tiene cada departamento ***********************/
select COUNT(e.idempleado) as 'numero de empleados', d.nombre
FROM Empleado as e
inner join Departamento as d on d.idDepartamento = e.idDepartamento
group by d.nombre

/*
[] 1 SELECT INTO CON DROP TABLE Y REINSERTAR LAS FILAS
*/
select idEmpleado, nombre, apPat, apMat, nomComp, edad, idDepartamento
into #empleado
from Empleado

drop table Empleado

create table Empleado(
	idEmpleado int NOT NULL,
	nombre varchar(50) NULL,
	apPat varchar(50) NULL,
	apMat varchar(50) NULL,
	nomComp  AS (nombre+' '+apPat+' '+apMat),
	edad int NULL,
	idDepartamento int NULL)

insert into  Empleado(idEmpleado, nombre, apPat, apMat, edad, idDepartamento)
select idEmpleado, nombre, apPat, apMat, edad, idDepartamento
from #empleado

select * from Empleado