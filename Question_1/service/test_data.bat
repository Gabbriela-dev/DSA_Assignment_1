@echo off
echo ==========================================
echo Q1 ASSET MANAGEMENT SYSTEM TEST DATA
echo ==========================================
echo.

echo [1] Creating institutions...
curl -s -X POST http://localhost:8080/assets/institutions -H "Content-Type: application/json" -d "{"name":"NUST"}"
echo.
curl -s -X POST http://localhost:8080/assets/institutions -H "Content-Type: application/json" -d "{"name":"UNAM"}"
echo.
echo.

echo [2] Creating Asset 1 - Available 3D Printer...
curl -s -X POST http://localhost:8080/assets -H "Content-Type: application/json" -d "{"assetTag":"NUST-LIB-3DP-001","name":"Pro-Series 3D Printer","description":"High-precision laboratory printer","institution":"NUST","site":"Main Campus","status":"AVAILABLE","dateAcquired":"2024-03-10","components":[],"schedules":[],"workOrders":[]}"
echo.
echo.

echo [3] Creating Asset 2 - Loaned Laptop...
curl -s -X POST http://localhost:8080/assets -H "Content-Type: application/json" -d "{"assetTag":"NUST-IT-LAP-001","name":"Dell Latitude 5540","description":"Staff laptop","institution":"NUST","site":"Main Campus","status":"LOANED_OUT","dateAcquired":"2023-08-15","components":[],"schedules":[],"workOrders":[]}"
echo.
echo.

echo [4] Creating Asset 3 - Maintenance Projector...
curl -s -X POST http://localhost:8080/assets -H "Content-Type: application/json" -d "{"assetTag":"UNAM-LIB-PROJ-001","name":"Epson Projector","description":"Lecture hall projector","institution":"UNAM","site":"Engineering Campus","status":"UNDER_MAINTENANCE","dateAcquired":"2022-06-20","components":[],"schedules":[],"workOrders":[]}"
echo.
echo.

echo [5] Creating Asset 4 - Disposed Desktop...
curl -s -X POST http://localhost:8080/assets -H "Content-Type: application/json" -d "{"assetTag":"UNAM-IT-PC-001","name":"Dell OptiPlex Desktop","description":"Retired office computer","institution":"UNAM","site":"Main Campus","status":"DISPOSED","dateAcquired":"2019-01-12","components":[],"schedules":[],"workOrders":[]}"
echo.
echo.

echo ==========================================
echo ADDING SCHEDULES
echo ==========================================
echo.

echo [6] Adding overdue maintenance schedule...
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/schedules -H "Content-Type: application/json" -d "{"scheduleId":"SCH-001","type":"MAINTENANCE","dueDate":"2026-01-01","description":"Overdue calibration"}"
echo.
echo.

echo [7] Adding future maintenance schedule...
curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/schedules -H "Content-Type: application/json" -d "{"scheduleId":"SCH-002","type":"MAINTENANCE","dueDate":"2026-12-15","description":"Annual laptop maintenance"}"
echo.
echo.

echo [8] Adding booking schedule...
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/schedules -H "Content-Type: application/json" -d "{"scheduleId":"SCH-003","type":"BOOKING","dueDate":"2026-10-10","description":"Reserved for student project"}"
echo.
echo.

echo [9] Adding another overdue maintenance schedule...
curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/schedules -H "Content-Type: application/json" -d "{"scheduleId":"SCH-004","type":"MAINTENANCE","dueDate":"2025-11-20","description":"Replace projector lamp"}"
echo.
echo.

echo ==========================================
echo ADDING COMPONENTS
echo ==========================================
echo.

echo [10] Adding printer components...
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components -H "Content-Type: application/json" -d "{"compId":"C101","name":"Stepper Motor","description":"X-axis motor"}"
echo.
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components -H "Content-Type: application/json" -d "{"compId":"C102","name":"Print Head","description":"High precision print head"}"
echo.
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components -H "Content-Type: application/json" -d "{"compId":"C103","name":"Heated Bed","description":"Temperature controlled print surface"}"
echo.
echo.

echo [11] Adding laptop component...
curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/components -H "Content-Type: application/json" -d "{"compId":"C201","name":"Battery","description":"Internal laptop battery"}"
echo.
echo.

echo [12] Adding projector component...
curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/components -H "Content-Type: application/json" -d "{"compId":"C301","name":"Projection Lamp","description":"High brightness projector lamp"}"
echo.
echo.

echo ==========================================
echo ADDING WORK ORDERS
echo ==========================================
echo.

echo [13] Adding printer work order...
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders -H "Content-Type: application/json" -d "{"orderId":"WO-001","status":"OPEN","description":"Nozzle heat-bed failure","tasks":[]}"
echo.
echo.

echo [14] Adding laptop work order...
curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders -H "Content-Type: application/json" -d "{"orderId":"WO-002","status":"IN_PROGRESS","description":"Battery replacement","tasks":[]}"
echo.
echo.

echo [15] Adding projector work order...
curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/workorders -H "Content-Type: application/json" -d "{"orderId":"WO-003","status":"OPEN","description":"Replace damaged projection lamp","tasks":[]}"
echo.
echo.

echo ==========================================
echo ADDING TASKS
echo ==========================================
echo.

echo [16] Adding printer tasks...
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks -H "Content-Type: application/json" -d "{"taskId":"T101","description":"Check thermal sensor connectivity"}"
echo.
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks -H "Content-Type: application/json" -d "{"taskId":"T102","description":"Inspect heating element"}"
echo.
curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks -H "Content-Type: application/json" -d "{"taskId":"T103","description":"Calibrate print bed"}"
echo.
echo.

echo [17] Adding laptop tasks...
curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders/WO-002/tasks -H "Content-Type: application/json" -d "{"taskId":"T201","description":"Order replacement battery"}"
echo.
curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders/WO-002/tasks -H "Content-Type: application/json" -d "{"taskId":"T202","description":"Install replacement battery"}"
echo.
echo.

echo [18] Adding projector task...
curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/workorders/WO-003/tasks -H "Content-Type: application/json" -d "{"taskId":"T301","description":"Remove damaged lamp"}"
echo.
echo.

echo ==========================================
echo FINAL ASSET STATES
echo ==========================================
echo.

echo [19] NUST 3D Printer:
curl -s http://localhost:8080/assets/NUST-LIB-3DP-001
echo.
echo.

echo [20] NUST Laptop:
curl -s http://localhost:8080/assets/NUST-IT-LAP-001
echo.
echo.

echo [21] UNAM Projector:
curl -s http://localhost:8080/assets/UNAM-LIB-PROJ-001
echo.
echo.

echo [22] UNAM Desktop:
curl -s http://localhost:8080/assets/UNAM-IT-PC-001
echo.
echo.

echo ==========================================
echo TEST DATA CREATION COMPLETE
echo ==========================================
pause
