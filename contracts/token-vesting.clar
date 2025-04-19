;; Define the map for beneficiary vesting schedules
(define-map beneficiary-vesting
  { beneficiary: principal }
  { total-amount: uint, start-time: uint, cliff-time: uint, duration: uint, claimed: uint })

;; Set the contract owner to the deployer of the contract
(define-constant contract-owner tx-sender)

;; Add a beneficiary with their vesting schedule
(define-public (add-beneficiary (beneficiary principal) (total-amount uint) (start-time uint) (cliff-time uint) (duration uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u100))
    (asserts! (> duration u0) (err u101))
    (asserts! (> total-amount u0) (err u102))
    (map-set beneficiary-vesting { beneficiary: beneficiary }
      { total-amount: total-amount, start-time: start-time, cliff-time: cliff-time, duration: duration, claimed: u0 })
    (ok "Beneficiary added")))

;; Calculate the vested amount for a beneficiary
(define-read-only (get-vested-amount (beneficiary principal))
  (let ((vesting-data (map-get? beneficiary-vesting { beneficiary: beneficiary })))
    (match vesting-data
      beneficiary-data
      (let ((current-time stacks-block-height)
            (start-time (get start-time beneficiary-data))
            (cliff-time (get cliff-time beneficiary-data))
            (duration (get duration beneficiary-data))
            (total-amount (get total-amount beneficiary-data))
            (claimed (get claimed beneficiary-data)))
        (if (< current-time cliff-time)
            (ok u0)
            (let ((elapsed (if (> current-time (+ start-time duration)) 
                              duration 
                              (- current-time start-time))))
              (ok (/ (* total-amount elapsed) duration)))))
      (err u103))))

;; Allow a beneficiary to claim their vested tokens
(define-public (claim-vested-tokens)
  (let ((vesting-data (map-get? beneficiary-vesting { beneficiary: tx-sender })))
    (match vesting-data
      beneficiary-data
      (let ((vested (unwrap! (get-vested-amount tx-sender) (err u104)))
            (claimed (get claimed beneficiary-data)))
        (let ((claimable (- vested claimed)))
          (asserts! (> claimable u0) (err u105))
          (map-set beneficiary-vesting { beneficiary: tx-sender }
            (merge beneficiary-data { claimed: (+ claimed claimable) }))
          (ok claimable)))
      (err u106))))