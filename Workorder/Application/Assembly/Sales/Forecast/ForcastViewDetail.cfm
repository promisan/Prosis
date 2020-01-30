<cf_layout type="border" id="mainLayout" width="95%" height="95%">	
			
	<cf_layoutArea 
			name       ="left" 
			position   ="left" 
			collapsible="true"
			size       ="15%" 
			minsize    ="150px" 
			overflow   ="scroll">
				<cfdiv id="divCustomers" bind="url:Customers.cfm?serviceItem={fltServiceItem}">
	</cf_layoutArea>
	
	<cf_layoutArea 
			name="center" 
			position="center">
				<cfdiv id="divForecastEntry" style="height:100%;" bind="url:ForecastEntry.cfm?serviceItem={fltServiceItem}&customerid=">
	</cf_layoutArea>
	
</cf_layout>