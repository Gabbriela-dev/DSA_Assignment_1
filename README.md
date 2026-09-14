# DSA_Assignment_1

# Distributed Systems Assignment 1 — Regional Healthcare & Education Management API

This is our group submission for DSA Assignment 1: a multi-resource RESTful HTTP web service built in Ballerina. It's a backend API for managing healthcare and education operations across a set of facilities and institutions.

## Group Members & Work Distribution: Question1

We split the work into three parts so each person owned a clear chunk of the system:

| Role | Student Name | Responsibilities & Assigned Modules |

| **Person A** | Gabbriela Kapitango | **Users & Sites Management** — user profiles, authentication, and role definitions; site registration (`/users`, `/sites`) |
| **Person B** | Erica Malima | **Schedules & Institutions Management** — event calendar and institution registry (`/schedules`, `/institutions`); filtering and overdue-schedule detection |
| **Person C** | Gabbriela Kapitango | **Reports & Analytical Dashboard** — regional performance summaries and stats (`/reports`); site activity auditing and system status |

## Key Features

- Full CRUD for Users, Sites, Institutions, Schedules, and Reports
- Filtering endpoints (e.g. `/schedules/filter`) with optional query parameters
- Overdue tracking — compares current UTC date against scheduled deadlines
- Payload validation via Ballerina closed records (`record {| ... |}`) plus regex checks for ISO dates (`YYYY-MM-DD`)
- In-memory data storage using indexed Ballerina `table` structures, protected with `lock` blocks for thread safety

## Project Structure

```text

├── Ballerina.toml   # Package manifest and dependencies
├── main.bal         # HTTP listener, service routes, and resource logic
├── types.bal        # Record types and schemas
└── README.md        # This file

## Prerequisites & Setup

You'll need the Ballerina Swan Lake runtime installed.

1. Check your version:
```bash
bal version
```
(Swan Lake Update 8 or later)

2. Clone the repo:
```bash
git clone https://gitlab.com/your-group-repo/dsa-assignment-1.git
cd dsa-assignment-1


3. Run it:
```bash
bal run

The service runs at `http://localhost:9090`.

## API Endpoints

### Gabbriela — Users & Sites (`/users`, `/sites`)
- `POST /users` — register a new user
- `GET /users` — list active user profiles
- `POST /sites` — create a new facility record
- `GET /sites` — list all sites

### Erica — Schedules & Institutions (`/schedules`, `/institutions`)
- `POST /institutions` — register a new institution (e.g. a Regional Health Board)
- `GET /institutions` — list all institutions
- `POST /schedules` — create a scheduled event
- `GET /schedules` — list all schedules
- `GET /schedules/filter?institutionId={id}&siteId={id}` — filter events by criteria
- `GET /schedules/overdue` — list overdue, uncompleted events
- `PUT /schedules/{id}` — update a schedule's status or title
- `DELETE /schedules/{id}` — delete a schedule

### Gabbriela — Reports & Analytics (`/reports`)
- `POST /reports` — generate a summary report

## Git Workflow

- Feature branches (`feature/person-a`, `feature/person-b`, `feature/person-c`) off `main`
- Merge conflicts were resolved with `git pull origin main` followed by a standard three-way merge
- Each person committed their own modules with descriptive messages to keep history readable
