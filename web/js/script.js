document.addEventListener('DOMContentLoaded', () => {
    // 1. Countdown Timer Logic
    const hoursSpan = document.getElementById('hours');
    const minutesSpan = document.getElementById('minutes');
    const secondsSpan = document.getElementById('seconds');

    if (hoursSpan && minutesSpan && secondsSpan) {
        let timeInSeconds = 2 * 3600 + 45 * 60 + 12;

        const updateTimer = () => {
            if (timeInSeconds <= 0) return;
            
            timeInSeconds--;
            
            const h = Math.floor(timeInSeconds / 3600);
            const m = Math.floor((timeInSeconds % 3600) / 60);
            const s = timeInSeconds % 60;

            hoursSpan.textContent = h.toString().padStart(2, '0');
            minutesSpan.textContent = m.toString().padStart(2, '0');
            secondsSpan.textContent = s.toString().padStart(2, '0');
        };

        setInterval(updateTimer, 1000);
    }
});
