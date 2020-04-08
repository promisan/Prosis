
<cfsavecontent variable="myCart">
			{
			"store":{"mission":"Bambino","Warehouse":"BAM03"},
			"customer":{"account":"administrator","AddressId":"00000000-0000-0000-0000-0000000000000","customerId":"E8AA636F-C94B-3437-B7E7-D3E237BB0DAE"},
			"products":[{"itemno":"28254","itemuom":"11","lot":"0","currency":"QTZ","quantity":10,"PriceSchedule":2},
			            {"itemno":"28255","itemuom":"11","lot":"0","currency":"QTZ","quantity":100,"PriceSchedule":2}
					   ]
			}			
</cfsavecontent>		

<cfinvoke component = "Service.Process.EDI.website.materials.Request"  
   method           = "addCart" 
   cart             = "#myCart#"   
   returnvariable   = "result">	   
			
			

