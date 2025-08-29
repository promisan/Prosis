<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<script type="text/javascript">

	var i=0;
	var doc=1;
	var vall=26;

	var o=new Array("diez", "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve", "veinte", "veintiuno", "veintidos", "veintitres", "veinticuatro", "veinticinco", "veintiseis", "veintisiete", "veintiocho", "veintinueve");
	var u=new Array("cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve");
	var d=new Array("", "", "", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa");
	var c=new Array("", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos");
	 
	function nn(n) {
	  var n=parseFloat(n).toFixed(2); /*se limita a dos decimales, no sabï¿½a que existï¿½a toFixed() :)*/
	  var p=n.toString().substring(n.toString().indexOf(".")+1); /*decimales*/
	  var m=n.toString().substring(0,n.toString().indexOf(".")); /*nï¿½mero sin decimales*/
	  var m=parseFloat(m).toString().split("").reverse(); /*tampoco que reverse() existï¿½a :D*/
	  var t="";
	 
	  /*Se analiza cada 3 dï¿½gitos*/
	  for (var i=0; i<m.length; i+=3) {
	    var x=t;
	    /*formamos un nï¿½mero de 2 dï¿½gitos*/
	    var b=m[i+1]!=undefined?parseFloat(m[i+1].toString()+m[i].toString()):parseFloat(m[i].toString());
	    /*analizamos el 3 dï¿½gito*/
	    t=m[i+2]!=undefined?(c[m[i+2]]+" "):"";
	    t+=b<10?u[b]:(b<30?o[b-10]:(d[m[i+1]]+(m[i]=='0'?"":(" y "+u[m[i]]))));
	    t=t=="ciento cero"?"cien":t;
	    if (2<i&&i<6)
	      t=t=="uno"?"mil ":(t.replace("uno","un")+" mil ");
	    if (5<i&&i<9)
	      t=t=="uno"?"un millï¿½n ":(t.replace("uno","un")+" millones ");
	    t+=x;
	    //t=i<3?t:(i<6?((t=="uno"?"mil ":(t+" mil "))+x):((t=="uno"?"un millï¿½n ":(t+" millones "))+x));
	  }
	 
	  t+=" con "+p+"/100";
	  /*correcciones*/
	  t=t.replace("  "," ");
	  t=t.replace(" cero","");
	  //t=t.replace("ciento y","cien y");
	  //alert("Numero: "+n+"\nNï¿½ Dï¿½gitos: "+m.length+"\nDï¿½gitos: "+m+"\nDecimales: "+p+"\nt: "+t);
	  //document.getElementById("esc").value=t;	  
	  
	  var capitalized = t.charAt(0).toUpperCase() + t.substring(1);   	  
	  return capitalized;
	}
	
    
    function break_line(num) {
		for (var j=1;j<=num;j++) { 
			document.jzebra.append("\x0B");
			i++;
		}
    }
    
    
    function spaces(num) {
    	st="";	
		for (var j=1;j<=num;j++) { 
			st=st+" ";
		}
		document.jzebra.append(st);
    }
    
    function complement(st, num) {
    	len = st.length;
    	for (var j=len;j<=num;j++) { 
			st=st+" ";
		}
		return st.substring(0,num);

    }    

    function complementN(st, num) {
    	len = st.length;
    	
		for (var j=len;j<=num;j++)	{ 
			st=" "+st;
		}
		return st;
    }   
    
	function get_last_one() {
    	vlast = vall - i+1;
		break_line(vlast);
    }    
    

	function findPrinter(pdoc) {

		doc = pdoc;
	    var applet = document.jzebra;
	    if (applet != null) {
			console.log(applet);
        	applet.findPrinter("EPSON");
    	}
    	monitorFinding();
	}
	
	function monitorFinding() {
	    var applet = document.jzebra;
	    if (applet != null) {
        	if (!applet.isDoneFinding()) {
          		window.setTimeout('monitorFinding()', 100);
        	} else {
          		var printer = applet.getPrinterName();
              	if (printer == null)
              	  alert("Impresora no encontrada");
              	else
              	{
					switch(doc)
					{
					case 1:
	              	   doPartida();
					  break;
					case 2:
              	      doCheque();
					  break;
					case 3:
              	      doInvoice();
					  break;
					default:
	
					}


              	} 
    	    }
    	} else {
	        alert("Applet not loaded!");
	    }
	}
	
</script>	

