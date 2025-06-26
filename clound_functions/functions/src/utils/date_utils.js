
formatDate = (date) => {
    const year = date.getFullYear()
    const month = String(data.getMonth() + 1).padStart(2, '0')
    const day = String(data.getDate()).padStart(2, '0')
    
    return `${year}-${month}-${day}`
}   

module.exports = formatDate