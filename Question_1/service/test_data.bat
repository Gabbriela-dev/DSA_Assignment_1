@echo off
setlocal

echo ==========================================
echo Q1 ASSET MANAGEMENT SYSTEM TEST DATA
echo ==========================================
echo.

echo [1] Creating institution NUST...
(
echo {"name":"NUST"}
) > "%TEMP%\q1_institution_nust.json"

curl -s -X POST http://localhost:8080/assets/institutions ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_institution_nust.json"

echo.
echo.

echo [2] Creating institution UNAM...
(
echo {"name":"UNAM"}
) > "%TEMP%\q1_institution_unam.json"

curl -s -X POST http://localhost:8080/assets/institutions ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_institution_unam.json"

echo.
echo.

echo [3] Creating Asset 1 - 3D Printer...
(
echo {"assetTag":"NUST-LIB-3DP-001","name":"Pro-Series 3D Printer","description":"High-precision laboratory printer","institution":"NUST","site":"Main Campus","status":"AVAILABLE","dateAcquired":"2024-03-10","components":[],"schedules":[],"workOrders":[]}
) > "%TEMP%\q1_asset1.json"

curl -s -X POST http://localhost:8080/assets ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_asset1.json"

echo.
echo.

echo [4] Creating Asset 2 - Laptop...
(
echo {"assetTag":"NUST-IT-LAP-001","name":"Dell Latitude 5540","description":"Staff laptop","institution":"NUST","site":"Main Campus","status":"LOANED_OUT","dateAcquired":"2023-08-15","components":[],"schedules":[],"workOrders":[]}
) > "%TEMP%\q1_asset2.json"

curl -s -X POST http://localhost:8080/assets ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_asset2.json"

echo.
echo.

echo [5] Creating Asset 3 - Projector...
(
echo {"assetTag":"UNAM-LIB-PROJ-001","name":"Epson Projector","description":"Lecture hall projector","institution":"UNAM","site":"Engineering Campus","status":"UNDER_MAINTENANCE","dateAcquired":"2022-06-20","components":[],"schedules":[],"workOrders":[]}
) > "%TEMP%\q1_asset3.json"

curl -s -X POST http://localhost:8080/assets ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_asset3.json"

echo.
echo.

echo [6] Creating Asset 4 - Desktop...
(
echo {"assetTag":"UNAM-IT-PC-001","name":"Dell OptiPlex Desktop","description":"Retired office computer","institution":"UNAM","site":"Main Campus","status":"DISPOSED","dateAcquired":"2019-01-12","components":[],"schedules":[],"workOrders":[]}
) > "%TEMP%\q1_asset4.json"

curl -s -X POST http://localhost:8080/assets ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_asset4.json"

echo.
echo.

echo ==========================================
echo ADDING SCHEDULES
echo ==========================================
echo.

echo [7] Adding overdue maintenance schedule...
(
echo {"scheduleId":"SCH-001","type":"MAINTENANCE","dueDate":"2026-01-01","description":"Overdue calibration"}
) > "%TEMP%\q1_schedule1.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/schedules ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_schedule1.json"

echo.
echo.

echo [8] Adding future maintenance schedule...
(
echo {"scheduleId":"SCH-002","type":"MAINTENANCE","dueDate":"2026-12-15","description":"Annual laptop maintenance"}
) > "%TEMP%\q1_schedule2.json"

curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/schedules ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_schedule2.json"

echo.
echo.

echo [9] Adding booking schedule...
(
echo {"scheduleId":"SCH-003","type":"BOOKING","dueDate":"2026-10-10","description":"Reserved for student project"}
) > "%TEMP%\q1_schedule3.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/schedules ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_schedule3.json"

echo.
echo.

echo [10] Adding overdue maintenance schedule...
(
echo {"scheduleId":"SCH-004","type":"MAINTENANCE","dueDate":"2025-11-20","description":"Replace projector lamp"}
) > "%TEMP%\q1_schedule4.json"

curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/schedules ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_schedule4.json"

echo.
echo.

echo ==========================================
echo ADDING COMPONENTS
echo ==========================================
echo.

echo [11] Adding printer component C101...
(
echo {"compId":"C101","name":"Stepper Motor","description":"X-axis motor"}
) > "%TEMP%\q1_component1.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_component1.json"

echo.
echo.

echo [12] Adding printer component C102...
(
echo {"compId":"C102","name":"Print Head","description":"High precision print head"}
) > "%TEMP%\q1_component2.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_component2.json"

echo.
echo.

echo [13] Adding printer component C103...
(
echo {"compId":"C103","name":"Heated Bed","description":"Temperature controlled print surface"}
) > "%TEMP%\q1_component3.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/components ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_component3.json"

echo.
echo.

echo [14] Adding laptop component...
(
echo {"compId":"C201","name":"Battery","description":"Internal laptop battery"}
) > "%TEMP%\q1_component4.json"

curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/components ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_component4.json"

echo.
echo.

echo [15] Adding projector component...
(
echo {"compId":"C301","name":"Projection Lamp","description":"High brightness projector lamp"}
) > "%TEMP%\q1_component5.json"

curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/components ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_component5.json"

echo.
echo.

echo ==========================================
echo ADDING WORK ORDERS
echo ==========================================
echo.

echo [16] Adding printer work order...
(
echo {"orderId":"WO-001","status":"OPEN","description":"Nozzle heat-bed failure","tasks":[]}
) > "%TEMP%\q1_workorder1.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_workorder1.json"

echo.
echo.

echo [17] Adding laptop work order...
(
echo {"orderId":"WO-002","status":"IN_PROGRESS","description":"Battery replacement","tasks":[]}
) > "%TEMP%\q1_workorder2.json"

curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_workorder2.json"

echo.
echo.

echo [18] Adding projector work order...
(
echo {"orderId":"WO-003","status":"OPEN","description":"Replace damaged projection lamp","tasks":[]}
) > "%TEMP%\q1_workorder3.json"

curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/workorders ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_workorder3.json"

echo.
echo.

echo ==========================================
echo ADDING TASKS
echo ==========================================
echo.

echo [19] Adding printer task T101...
(
echo {"taskId":"T101","description":"Check thermal sensor connectivity"}
) > "%TEMP%\q1_task1.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task1.json"

echo.
echo.

echo [20] Adding printer task T102...
(
echo {"taskId":"T102","description":"Inspect heating element"}
) > "%TEMP%\q1_task2.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task2.json"

echo.
echo.

echo [21] Adding printer task T103...
(
echo {"taskId":"T103","description":"Calibrate print bed"}
) > "%TEMP%\q1_task3.json"

curl -s -X POST http://localhost:8080/assets/NUST-LIB-3DP-001/workorders/WO-001/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task3.json"

echo.
echo.

echo [22] Adding laptop task T201...
(
echo {"taskId":"T201","description":"Order replacement battery"}
) > "%TEMP%\q1_task4.json"

curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders/WO-002/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task4.json"

echo.
echo.

echo [23] Adding laptop task T202...
(
echo {"taskId":"T202","description":"Install replacement battery"}
) > "%TEMP%\q1_task5.json"

curl -s -X POST http://localhost:8080/assets/NUST-IT-LAP-001/workorders/WO-002/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task5.json"

echo.
echo.

echo [24] Adding projector task T301...
(
echo {"taskId":"T301","description":"Remove damaged lamp"}
) > "%TEMP%\q1_task6.json"

curl -s -X POST http://localhost:8080/assets/UNAM-LIB-PROJ-001/workorders/WO-003/tasks ^
-H "Content-Type: application/json" ^
--data-binary "@%TEMP%\q1_task6.json"

echo.
echo.

echo ==========================================
echo FINAL ASSET STATES
echo ==========================================
echo.

echo [25] NUST 3D Printer:
curl -s http://localhost:8080/assets/NUST-LIB-3DP-001
echo.
echo.

echo [26] NUST Laptop:
curl -s http://localhost:8080/assets/NUST-IT-LAP-001
echo.
echo.

echo [27] UNAM Project
