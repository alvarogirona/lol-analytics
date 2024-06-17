import Chart from "chart.js/auto"

const ChampionWinRate = {
    mounted() {
        this.handleEvent("win-rate", ({ winRates }) => {
            this.patches = winRates.map((winRate) => {
                return winRate.patch_number
            })
            this.winRateValues = winRates.map((winRate) => winRate.win_rate)
            // TODO: it breaks on resizing, should apply a better fix...
            setInterval(() => {
                const data = {
                    labels: this.patches,
                    datasets: [{
                        data: this.winRateValues,
                        fill: false,
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                };
                this.chart = new Chart(document.getElementById("win-rate"), {
                    type: 'line',
                    data: data,
                    options: {
                        plugins: {
                            legend: {
                                display: false
                            }
                        }
                    }
                })
                this.chart.canvas.parentNode.style.height = '250px';
                this.chart.canvas.parentNode.style.width = '400px';
                this.chart.labels.display = false;
                this.chart.options.legend.display = false
                this.chart.options.legend.display = false
            }, 1000)
        });
    }
}

export { ChampionWinRate };