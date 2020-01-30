
<!--- pass true to geenrate the document --->

<cfreport 
	   template     = "Annex.cfr" 
	   format       = "PDF" 
	   overwrite    = "yes" 
	   encryption   = "none"
	   filename     = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf">
			<cfreportparam name = "ID"  value="#Object.ObjectKeyValue4#"> 
	</cfreport>	