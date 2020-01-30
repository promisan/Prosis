   <cfchart
       format="png"
       chartheight="130"
       chartwidth="150"
       showygridlines="yes"
       seriesplacement="default"
       labelformat="number"
	   showlegend="no"
	   backgroundcolor="ffffff"
	   showborder="no"
       show3d="no"
	   fontsize="9"
	   font="Verdana"				   
	   pieslicestyle="solid"
	   showxgridlines="yes"
       sortxaxis="no"
       xAxisTitle="Status"
	   yAxisTitle="Projects">
														   
	   <cfchartseries
        type="pie"
        query="Chart"
        itemcolumn="Description"
        valuecolumn="Total"
        serieslabel="Output status"
        paintstyle="light"
        markerstyle="circle"/> 
					
	</cfchart>	

<!---
	tipbgcolor="E9E9D1" --->
		