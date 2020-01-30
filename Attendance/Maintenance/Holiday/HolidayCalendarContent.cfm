<!--- display calendar start --->

<cfparam name="url.selecteddate" default="#now()#">
				
<cf_calendarView 
   title          = "Holidays"	
   selecteddate   = "#url.selecteddate#"
   relativepath   =	"../../.."		  
   content        = "Attendance/Maintenance/Holiday/getHoliday.cfm"			  
   target         = "Attendance/Maintenance/Holiday/setHoliday.cfm"
   condition      = "mission=#url.mission#&idmenu=#url.idmenu#"
   showJump       = "No"
   scroll         = "No"  
   cellwidth      = "40"
   cellheight     = "45">