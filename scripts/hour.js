function getRandomIntBetween(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

function getRandomMorningTime() {
    const hour = getRandomIntBetween(8, 10);

    if (hour > 8) {
        return `0${hour}:0${getRandomIntBetween(0, 4)}`;
    } else {
        return `0${hour}:${getRandomIntBetween(55, 60)}`;
    }
}

function getRandomLunchTime() {
    const hour = getRandomIntBetween(11, 13);

    if (hour > 11) {
        return `${hour}:0${getRandomIntBetween(0, 3)}`;
    } else {
        return `${hour}:${getRandomIntBetween(55, 60)}`;
    }
}

function getRandomReturnTime() {
    return `13:0${getRandomIntBetween(0, 4)}`;
}

function getRandomEndTime() {
    return `18:0${getRandomIntBetween(0, 6)}`;
}

const timeTable = {
    start: getRandomMorningTime(),
    lunch: getRandomLunchTime(),
    afterLunch: getRandomReturnTime(),
    end: getRandomEndTime(),
};
const timeTableCSV = Object.keys(timeTable)
    .map(key => timeTable[key])
    .join();

console.table(timeTable);
console.log(timeTableCSV);
