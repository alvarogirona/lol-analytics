import Chart from "chart.js/auto"

const ChampionWinRate = {
    mounted() {
        this.handleEvent("win-rate", ({ winRates }) => {
            this.sortedWinRates = winRates.sort((a, b) => {
                let [p1Major, p1Minor] = a.patch_number.split(".").map(Number);
                let [p2Major, p2Minor] = b.patch_number.split(".").map(Number);


                if (p1Major > p2Major || (p1Major == p2Major && p1Minor > p2Minor)) return 1;
                return -1
            })
            this.patches = this.sortedWinRates.map((winRate) => {
                return winRate.patch_number
            })
            this.winRateValues = this.sortedWinRates.map((winRate) => winRate.win_rate)
            // TODO: it breaks on liveview updates, should apply a better fix...
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