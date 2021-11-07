INSERT INTO Fact.Orden 
(
	[status], 
	[TipoDocumento], 
	[FechaCreacionCotizacion], 
	[FechaModificacionCotizacion], 
	[ProcesadoPor], 
	[AseguradoraSubsidiaria], 
	[NumeroReclamo], 
	[OrdenRealizada], 
	[CotizacionRealizada], 
	[CotizacionDuplicada], 
	[procurementFolderID], 
	[DireccionEntrega1], 
	[DireccionEntrega2], 
	[MarcadoEntrega], 
	[IDPartner], 
	[CodigoPostal],
	[NumLinea],
	[ID_Partes],
	Cantidad,
	Total_Orden,
	LeidoPorPlantaReparacion,
	FechaCreacionRegistro,
	PartnerConfirmado,
	SeguroValidado,
	[Ruta] , 
	[FechaLimiteRuta] , 
	[TelefonoEntrega] ,
	[OETipoParte] , 
	[AltPartNum] , 
	[AltTipoParte] , 
	[ciecaTipoParte] , 
	[partDescripcion] , 
	[CantidadCD] , 
	[PrecioListaOnRO] , 
	[PrecioNetoOnRO] , 
	[NecesitadoParaFecha],
	SK_Partes,
	SK_Geografia,
	SK_Clientes,
	SK_Vehiculo,
	SK_Descuento,
	SK_StatusOrden,
	SK_Aseguradoras,
	ID_Orden,
	ID_Cliente,
	ID_Ciudad,
	ID_StatusOrden,
	ID_DetalleOrden,
	IDCotizacion,
	IDAseguradora,
	IDPlantaReparacion,
	ID_Descuento,
	VehiculoID,
	Fecha_Orden,
	NumeroOrden,
	LeidoPorPlantaReparacionFecha,
	CotizacionReabierta,
	EsAseguradora,
	CodigoVerificacion,
	IDClientePlantaRepacion,
	IDRecotizacion,
	SK_Clientes

	) 
	select 
	[status] ,
	[TipoDocumento] ,
	[FechaCreacionCotizacion] ,
	[FechaModificacionCotizacion] ,
	[ProcesadoPor] ,
	[AseguradoraSubsidiaria] ,
	[NumeroReclamo] ,
	[OrdenRealizada] ,
    [CotizacionRealizada] , 
	[CotizacionDuplicada] , 
	[procurementFolderID] , 
	[DireccionEntrega1] , 
	[DireccionEntrega2] , 
	[MarcadoEntrega] , 
	[IDPartner] , 
	[CodigoPostal],
	NumLinea,
	ID_Parte,
	Cantidad,
	Total_Orden,
	LeidoPorPlantaReparacion,
	FechaCreacionRegistro,
	PartnerConfirmado,
	SeguroValidado,
	[Ruta] , 
	[FechaLimiteRuta] , 
	[TelefonoEntrega] ,
	[OETipoParte] , 
	[AltPartNum] , 
	[AltTipoParte] , 
	[ciecaTipoParte] , 
	[partDescripcion] , 
	[CantidadCD] , 
	[PrecioListaOnRO] , 
	[PrecioNetoOnRO] , 
	[NecesitadoParaFecha],
	ID_Geografia as SK_Partes,
	ID_Geografia,
	ID_Cliente,
	VehiculoID,
	ID_Descuento,
	ID_StatusOrden,
	IDAseguradora,
	ID_Orden,
	ID_Cliente,
	ID_Ciudad,
	ID_StatusOrden,
	ID_DetalleOrden,
	IDCotizacion,
	IDAseguradora,
	IDPlantaReparacion,
	ID_Descuento,
	VehiculoID,
	Fecha_Orden,
	NumeroOrden,
	LeidoPorPlantaReparacionFecha,
	CotizacionReabierta,
	EsAseguradora,
	CodigoVerificacion,
	IDClientePlantaRepacion,
	IDRecotizacion,
	ID_Cliente as SK_Clientes

	from staging.Orden

	select *
	from Fact.Orden


	