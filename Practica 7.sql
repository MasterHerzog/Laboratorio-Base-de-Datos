/*Practica 7*/
use BDHotel
/*1 procedimiento tipo script*/
/*agrega un cliente*/
create procedure AgregarCliente(
	@idCliente int,
	@nombre nvarchar(50),
	@apPat nvarchar(50),
	@apMat nvarchar(50)
)
as 
begin
	insert into Cliente(idCliente, nombre, apPat, apMat)
	values (@idCliente,@nombre, @apPat, @apMat)
end

exec AgregarCliente @idCliente = 9, @nombre = 'Pedro', @apPat = 'Guzman', @apMat = 'Dominguez'

/*5 procedimientos almacenados*/
/*1 - muestra losempleados que hay en un departamento en especifico*/
create procedure EmpleadosDepartamento(
	@idDepartamento int
)
as 
begin
	select (e.Nombre + ' ' + e.ApPat+ ' ' +e.ApMat) as NombreCompleto,
		 d.nombre
	 from Empleado as e
	left join Departamento as d on d.idDepartamento = e.idDepartamento
	 where d.idDepartamento = @idDepartamento
end

exec EmpleadosDepartamento @idDepartamento = 3

drop procedure EmpleadosDepartamento

/*2 - muestra cuantas veces se ha pedido un servicio en especifico*/

create procedure ServicioPedido(
	@idServicio int
)
as 
begin
  select count(c.idCliente) as 'numero de clientes', s.nombre
	from venta as v
	inner join cliente as c on c.idCliente = v.idCliente
	inner join ServiciosVendidos as sv on sv.idVenta = v.idVenta
	inner join Servicio as s on s.idServicio = sv.idServicio
	where s.idServicio = @idServicio
	group by s.nombre
end

exec ServicioPedido @idservicio = 2

drop procedure ServicioPedido

/*3 - muestra el numero de empleados que hay en un departamento en especifico*/
create procedure EmpleadosPorDepartamento(
	@idDepartamento int
)
as 
begin
	select COUNT(e.idempleado) as 'numero de empleados', d.nombre
	FROM Empleado as e
	inner join Departamento as d on d.idDepartamento = e.idDepartamento
	where d.idDepartamento = @idDepartamento
	group by d.nombre
end

exec EmpleadosPorDepartamento @idDepartamento = 3

/*4 - muestra los servicios solicitados por un cliente en espesifico*/

create procedure ClienteServicio(
	 @nombre nvarchar (50)
)
as 
begin
	declare @query nvarchar (max)
	set @query ='
	select v.idVenta,
	     c.nombre,c.apPat,
	     s.*
	from venta as v
	inner join cliente as c on c.idCliente = v.idCliente
	inner join ServiciosVendidos as sv on sv.idVenta = v.idVenta
	inner join Servicio as s on s.idServicio = sv.idServicio
	where c.nombre like ''' + @nombre +''''

	exec (@query)
end

exec ClienteServicio @nombre = 'Pablo'

drop procedure ClienteServicio

/*5 - cambia el nombre de un empleado y muestra el cambio*/

create procedure UpNombreEmpleado(
	 @nombre nvarchar (50),
	 @idEmpleado int
)
as 
begin

select idEmpleado, nombre
into #empleado
from Empleado

update Empleado set nombre = @nombre
where idEmpleado = @idEmpleado

select idEmpleado, nombre as ViejoNombre 
from #empleado
where idEmpleado = @idEmpleado

select idEmpleado, nombre as NuevoNombre 
from Empleado
where idEmpleado = @idEmpleado
end

exec UpNombreEmpleado @idEmpleado = 1, @nombre = 'Pepe'

drop procedure UpNombreEmpleado

/*1 Funcion*/
/*Muestra los sueldos que hay que pagar en total*/
create function SueldoEmpleado(
) returns decimal
as begin
	
	declare @sueldo decimal = (select sum(n.SueldoTotal) as Sueldo
								from Nomina as n)

	return @sueldo
end

select dbo.SueldoEmpleado() as 'sueldo por empleado'

drop function SueldoEmpleado