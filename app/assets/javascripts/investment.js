document.addEventListener("DOMContentLoaded", function() {
	data = [
			{"name":"Bitcoin","price_usd":41571.31627839723,"cripto_balance":0.0002405504779553145,"month_return":0.0000010022936581471438,"year_return":0.000012027523897765726},
			{"name":"Ethereum","price_usd":2275.17918328004,"cripto_balance":0.030766807517587973,"month_return":0.0001076838263115579,"year_return":0.001292205915738695},
			{"name":"Cardano","price_usd":0.5969326615095039,"cripto_balance":33.50461666718764,"month_return":0.027920513889323036,"year_return":0.3350461666718764}
		];
		updateTable(data);
		downloadButtons(data)

	document.getElementById("submit-btn").addEventListener("click", function() {
			const formData = new FormData(document.getElementById("csv-form"));

			fetch('/investment/balance', {
					method: 'POST',
					body: formData
			})
			.then(response => response.json())
			.then(data => {
					updateTable(data);
					downloadButtons(data)
			})
			.catch(error => {
				updateTable(data);
				downloadButtons(data)
					console.error('Error al enviar el formulario:', error);
			});
	});
});

function updateTable(data) {
	const tableContainer = document.getElementById("table-cripto");
	const criptoName = document.getElementById("cripto-name");
	const priceUsd = document.getElementById("price-usd");
	const totalCurrency = document.getElementById("total-currency");
	const returnMonth = document.getElementById("return-month");
	const returnYear = document.getElementById("return-year");

	data.forEach(cripto => {
			const name = createTableCell('th', cripto.name);
			const price = createTableCell('td', cripto.price_usd.toFixed(8));
			const total = createTableCell('td', cripto.cripto_balance.toFixed(8));
			const balanceMonth = createTableCell('td', cripto.month_return.toFixed(8));
			const balanceYear = createTableCell('td', cripto.year_return.toFixed(8));



			criptoName.appendChild(name);
			priceUsd.appendChild(price);
			totalCurrency.appendChild(total);
			returnMonth.appendChild(balanceMonth);
			returnYear.appendChild(balanceYear);
	});

	tableContainer.classList.remove('d-none');
}

function createTableCell(tag, text) {
	const cell = document.createElement(tag);
	cell.textContent = text;
	if(tag == 'th'){
		var imagen = document.createElement("img");
		imagen.src = '/assets/'+text+'.png';
		imagen.width = 35
		imagen.classList.add("mx-2")
		cell.appendChild(imagen)
	}
	return cell;
}

function downloadButtons(data){
	const downloadjsonBtn = document.getElementById('downloadJsonBtn');
	const downloadcsvBtn = document.getElementById('downloadCsvBtn');

	downloadjsonBtn.addEventListener('click', function() {
		downlodJson(data);
	});
	downloadcsvBtn.addEventListener('click', function() {
		downloadCsv(data)
	});
}

function downloadJson(data) {
	const blob = new Blob([JSON.stringify(data)], { type: 'application/json' });
	const url = URL.createURL(blob);
	const link = document.createElement('a');
	link.href = url;
	link.download = 'datos.json';
	link.click();
	URL.revokeObjectURL(url);
}

function downloadCsv(data){
	let datosCSV = "nombre,precio,cripto balance,retorno mes,retorno anual\n";
	data.forEach(cripto => {
			datosCSV += `${cripto.name},${cripto.price_usd},${cripto.cripto_balance},${cripto.month_return},${cripto.year_return}\n`;
	});
	const blob = new Blob([datosCSV], { type: 'text/csv' });
	const url = URL.createObjectURL(blob);
	const link = document.createElement('a');
	link.href = url;
	link.download = 'datos.csv';
	document.body.appendChild(link);
	link.click();
	document.body.removeChild(link);
	URL.revokeObjectURL(url);
}