
<cf_systemscript>

<cfoutput>
		
	<script language="JavaScript">		
	     
		function  change(obj,nid) {
			obj.className=nid;
		}		   
				
		function doNext(fn,mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group)	{
		
		  var result = window[fn](); 		
		  if (result)	{ 
			  nextstep(mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group);
	      }				  
	   }	
	   
	   function nextstep(mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group) {	
			ptoken.location("#SESSION.root#/tools/Process/Navigation/NavigationNext.cfm?mission="+mis+"&owner="+owner+"&code="+code+"&alias="+alias+"&tablename="+tablename+"&object="+object+"&objectid="+objectid+"&id="+id+"&id1="+event+"&prior="+listingorder+"&move="+moveto+"&group="+group) 
		}					  
					
	</script>

</cfoutput>