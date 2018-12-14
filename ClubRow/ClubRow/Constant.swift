//
//  File.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/26/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

let APP_NAME = "ClubRow"
let SERVER_URL = "http://159.89.117.106:4000/api/"

// API KEYS
let KEY_API_SIGNUP = "users"
let KEY_API_SIGNIN = "sessions"
let KEY_API_LOAD_LOBBIES = "lobbies"
let KEY_API_LOAD_LIVE_CLASSES = "classes/live"
let KEY_API_LOAD_FEATURED_CLASSES = "classes/featured"
let KEY_API_LOAD_ALL_INSTRUCTORS = "users/instructors"
let KEY_API_LOAD_CLASSES_FOR_INSTRUCTOR = "teachers"

// FIELD KEYS
let KEY_USER = "user"
let KEY_EMAIL = "email"
let KEY_PASSWORD = "password"
let KEY_TOKEN = "token"
let KEY_FIRST_NAME = "first_name"
let KEY_LAST_NAME = "last_name"
let KEY_PASSWORD_CONFIRMATION = "password_confirmation"



//Lobby
let KEY_LOBBY_STATE_ACCEPTING = "accepting_participants"
let KEY_LOBBY_STATE_PROGRESS = "workout_in_progress"
let KEY_LOBBY_STATE_FINISHED = "workout_finished"


//messages

//sign up
let MSG_SIGNUP_FIRST_NAME_EMPTY = "First name should not be empty"
let MSG_SIGNUP_LAST_NAME_EMPTY = "Last name should not be empty"
let MSG_SIGNUP_EMAIL_EMPTY = "Email should not be empty"
let MSG_SIGNUP_PASSWORD_EMPTY = "Password should not be empty"
let MSG_SIGNUP_PASSWORD_CONFIRM_EMPTY = "Password confirmation should not be empty"
let MSG_SIGNUP_EMAIL_FORMAT_ERROR = "Email should be formatted like example@example.com"
let MSG_SIGNUP_PASSWORD_CONFIRM_ERROR = "Password does not match confirmation"
let MSG_SIGNUP_SUCCESS = "The account has been registered successfully."
let MSG_SIGNUP_FAILED_UNKNOWN = "Signup was failed."
let MSG_SIGNUP_FAILED_NETWORK = "Signup was failed due to network connection.\nPlease check your network."

//login
let MSG_SIGNIN_FAILED_UNKNOWN = "Login was failed."
let MSG_SIGNIN_FAILED_NETWORK = "Login was failed due to network connection.\nPlease check your network."

//Home
let MSG_HOME_FAILED_LOAD_CLASSES = "Failed to load live classes"

// Instructors
let MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS = "Failed to load all instructors"
let MSG_INSTRUCTOR_INVAILD_ID = "Instructor information is invalid"

//lobby
let MSG_LOBBY_WAITING_FOR_PLAYER = "Waiting for workout to start..."
let MSG_LOBBY_FINISHED = "Lobby has been finished."

