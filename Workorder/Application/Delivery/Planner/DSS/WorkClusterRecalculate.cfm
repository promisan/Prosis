
<cfset objMatrix = CreateObject("component","service.maps.routing")/>

<cfset objMatrix.recalculate(date = "#URL.date#",step = "#URL.step#")/>
					
					
					