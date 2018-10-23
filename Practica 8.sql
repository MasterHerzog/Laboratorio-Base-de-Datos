use BDHotel

/******************************  Trigger after-update  ********************************************/
create trigger dbo.tr_update
on dbo.Empleado
after update
as
begin
	select *
	from INSERTED
	select*
	from DELETED
	--update
END

update Empleado set nombre = 'Jose'
from Empleado
where idEmpleado = 1

select * from empleado

/******************************  Trigger instead-delete  ********************************************/

create trigger dbo.tr_delete_Empleado
on dbo.Empleado
instead of delete
as
begin
	select *
	from DELETED
END

delete from Empleado where idEmpleado = 1

/******************************  Trigger instead-insert  ********************************************/

create trigger dbo.tr_insert_Habitacion
on dbo.Habitacion
instead of insert
as
begin
	select *
	from INSERTED
END

insert into Habitacion(idHabitacion,clase,piso, costoDiario) values (10,'primera',4, 6000)