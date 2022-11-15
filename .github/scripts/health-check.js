const fs = require('fs')
const Octokit = require("@octokit/action")

const octokit = new Octokit()
const [owner, repo] = process.env.GITHUB_REPOSITORY.split("/")
const run_id = process.env.RUN_ID

const { data } = await octokit.request('GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts', {
    owner,
    repo,
    run_id
})

const lastArtifact = data.artifacts.length - 1
const lastArtifactDownloadUrl = data[lastArtifact].archive_download_url

console.log(lastArtifactDownloadUrl)

const reg = new RegExp('"url": "https://example.com/"')
const webhookObjectPath = './.github/objects/health-check.json'
let webhookObject = fs.readFileSync(webhookObjectPath, 'utf-8')
webhookObject = webhookObject.replace(reg, `"url": "${lastArtifactDownloadUrl}"`)

console.log(webhookObject)

function webhook() {
    const fetch = require('node-fetch');
    const webhookURL = 'https://chat.googleapis.com/v1/spaces/AAAAZa98Rsk/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=jvYOOOuEndWxPSf99FtoePEQoPMcz_0HcLLebhqoj6U%3D';

    const data = JSON.stringify(webhookObject);
    let resp;
    fetch(webhookURL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data,
    }).then((response) => {
        resp = response;
        console.log(response);
    });
    return resp;
}

// webhook()