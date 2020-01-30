
<!--- pass true to geenrate the document --->

<cfreport 
	template     = "Ticket.cfr" 
	format       = "PDF" 
	overwrite    = "yes" 
	encryption   = "none">
		<cfreportparam name = "BatchNo"  value="#url.batchno#"> 
</cfreport>	