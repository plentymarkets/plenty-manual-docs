const fs = require('fs')

const changelogTemplate = './templates/changelog-yyyy-mm-dd.adoc'
const changelogFolder = './docs/de-de/modules/changelog/pages/'
const dateOptions = { year: 'numeric', month: 'long', day: 'numeric'}

const endDate = new Date()
const endWeekDate = new Intl.DateTimeFormat('de-de', dateOptions).format(endDate)

const endYear = endDate.getFullYear()
const endMonth = String(endDate.getMonth()).padStart(2, '0')
const endDay = String(endDate.getDate()).padStart(2, '0')
const startDate = new Date(endYear, endMonth, endDay - 6)
const startWeekDate = new Intl.DateTimeFormat('de-de', dateOptions).format(startDate)

const fileMonth = String(endDate.getMonth() + 1).padStart(2, '0')
const fileNameDate = [endYear, fileMonth, endDay].join('-')

const newChangelogPath = `${changelogFolder}${fileNameDate}.adoc`

fs.copyFileSync(`${changelogTemplate}`, `${newChangelogPath}`)

fs.readdirSync(changelogFolder).forEach(file => {
    const filePath = `${changelogFolder}${file}`
    const pageAlias = ':page-aliases: ROOT:changelog.adoc'
    
    if (fs.readFileSync(filePath).includes(pageAlias) && filePath !== newChangelogPath){
        const oldChangelog = fs.readFileSync(filePath, 'utf-8')
        const newChangelog = fs.readFileSync(newChangelogPath, 'utf-8')
        const regEarly = new RegExp(':version: early.+?--', 's')
        const regStable = new RegExp(':version: stable.+?--', 's')
        const earlyChanges = oldChangelog.match(regEarly)[0]
        const newStableChanges = earlyChanges.replace(':version: early', ':version: stable')
        let oldChangelogUpdated = oldChangelog
        let newChangelogUpdated = newChangelog

        newChangelogUpdated = newChangelogUpdated.replace(
            '= Changelog DD. Monat JJJJ', `= Changelog ${endWeekDate}`
        )
        newChangelogUpdated = newChangelogUpdated.replace(
            ':startWeekDate: DD. Monat JJJJ', `:startWeekDate: ${startWeekDate}`
        )
        newChangelogUpdated = newChangelogUpdated.replace(
            ':endWeekDate: DD. Monat JJJJ', `:endWeekDate: ${endWeekDate}`
        )
        newChangelogUpdated = newChangelogUpdated.replace(
            regStable, newStableChanges
        )
        fs.writeFileSync(newChangelogPath, newChangelogUpdated, 'utf-8')

        oldChangelogUpdated = oldChangelogUpdated.replace(
            `${pageAlias}\n`, ''
        )
        fs.writeFileSync(filePath, oldChangelogUpdated, 'utf-8')
    }
  });
