// AppSearch.qml
pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property var applications: DesktopEntries.applications.values.filter(app => !app.noDisplay && !app.runInTerminal)

  function searchApplications(query) {
    if (!query || query.length === 0)
        return applications
    if (applications.length === 0)
        return []

    const queryLower = query.toLowerCase().trim()
    const scoredApps = []

    for (const app of applications) {
      const name = (app.name || "").toLowerCase()
      const genericName = (app.genericName || "").toLowerCase()
      const comment = (app.comment || "").toLowerCase()
      const keywords = app.keywords ? app.keywords.map(k => k.toLowerCase()) : []

      let score = 0
      let matched = false

      const nameWords = name.trim().split(/\s+/).filter(w => w.length > 0)
      const containsAsWord = nameWords.includes(queryLower)
      const startsWithAsWord = nameWords.some(word => word.startsWith(queryLower))

      if (name === queryLower) {
        score = 10000
        matched = true
      } else if (containsAsWord) {
        score = 9500 + (100 - Math.min(name.length, 100))
        matched = true
      } else if (name.startsWith(queryLower)) {
        score = 9000 + (100 - Math.min(name.length, 100))
        matched = true
      } else if (startsWithAsWord) {
        score = 8500 + (100 - Math.min(name.length, 100))
        matched = true
      } else if (name.includes(queryLower)) {
        score = 8000 + (100 - Math.min(name.length, 100))
        matched = true
      } else if (keywords.length > 0) {
        for (const keyword of keywords) {
            if (keyword === queryLower) {
                score = 6000
                matched = true
                break
            } else if (keyword.startsWith(queryLower)) {
                score = 5500
                matched = true
                break
            } else if (keyword.includes(queryLower)) {
                score = 5000
                matched = true
                break
            }
        }
      }
      if (!matched && genericName.includes(queryLower)) {
        score = 4000
        matched = true
      } else if (!matched && comment.includes(queryLower)) {
        score = 3000
        matched = true
      }

      if (matched) {
        scoredApps.push({
                            "app": app,
                            "score": score
                        })
      }
    }

    scoredApps.sort((a, b) => b.score - a.score)
    return scoredApps.slice(0, 15).map(item => item.app)
  }
}