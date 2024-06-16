import Chart from "chart.js/auto"

const ChampionWinRate = {
    mounted() {
        console.log("mounted")
        this.handleEvent("points", (event) => console.log("123"))

        // this.props = { id: this.el.getAttribute("data-id") };
        this.handleEvent("win-rate", ({ winRates }) => {
            console.log(">>>>>>>")
            console.log(winRates);
            patches = winRates.map((winRate) => {
                return winRate.patch_number
            })
            winRateValues = winRates.map((winRate) => winRate.win_rate)
            setInterval(() => {
                const data = {
                    labels: patches,
                    datasets: [{
                        label: 'Win rate',
                        data: winRateValues,
                        fill: false,
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                };
                this.chart = new Chart(document.getElementById("win-rate"), {
                    type: 'line',
                    data: data
                })
                this.chart.canvas.parentNode.style.height = '250px';
                this.chart.canvas.parentNode.style.width = '400px';
            }, 1000)
        });
    }
}

export { ChampionWinRate };