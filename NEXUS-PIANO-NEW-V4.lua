--[[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║     TALENTLESS V4 — MEGA EDITION  |  Auto Piano Exploit                     ║
║         Rayfield UI | 130+ Músicas | Dueto | Loop | Efeitos | Ritmo         ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   DESENVOLVIDO POR:                                                          ║
║     Beicon_129 (333)  —  Criador & Lead Developer                           ║
║     Dkgune (Rdd)      —  Co-Developer & Contribuidor                        ║
║     Davi Scripts       —  Contribuidor & Tester                             ║
║     C00Ikiddban        —  Contribuidor & Community                          ║
║                                                                              ║
║   VERSÃO: 4.0.0 MEGA EDITION  |  Rayfield  |  130+ Músicas                ║
║                                                                              ║
║   CONTROLES:                                                                 ║
║     F2 = Play/Pause  |  F3 = Stop  |  F4 = Next  |  F5 = Prev             ║
║     F6 = Loop        |  F7 = Shuffle  |  F8 = Humanize Toggle              ║
║     F1 = Mostrar/Ocultar GUI  |  F9 = Loop de Trecho                       ║
║                                                                              ║
║   NOVIDADES V4:                                                              ║
║     ✦ Sistema de Dueto (2 players)                                          ║
║     ✦ Compartilhar música por código                                        ║
║     ✦ Modo Ritmo / Guitar Hero                                              ║
║     ✦ Efeitos: Reverb, Delay, Echo                                          ║
║     ✦ Sistema de Performance / Pontuação                                    ║
║     ✦ Loop de Trecho                                                        ║
║     ✦ 30+ Músicas Novas                                                     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
]]

-- ══════════════════════════════════════════════════════════════
--  SERVIÇOS DO ROBLOX
-- ══════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer       = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
--  CARREGAR RAYFIELD
-- ══════════════════════════════════════════════════════════════
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ══════════════════════════════════════════════════════════════
--  INFORMAÇÕES DA VERSÃO
-- ══════════════════════════════════════════════════════════════
local VERSION = {
    major = 4, minor = 0, patch = 1,
    tag   = "MEGA EDITION (Rayfield) + Talentless Songs",
    full  = "4.0.1 MEGA",
    codename = "Nexus",
}

local CREDITS = {
    { name = "Beicon_129 (333)", role = "Criador & Lead Developer",   emoji = "👑" },
    { name = "Dkgune (Rdd)",     role = "Co-Developer & Contribuidor", emoji = "⚡" },
    { name = "Davi Scripts",     role = "Contribuidor & Tester",       emoji = "🛠️" },
    { name = "C00Ikiddban",      role = "Contribuidor & Community",    emoji = "🌟" },
}

-- ══════════════════════════════════════════════════════════════
--  CONFIGURAÇÕES GLOBAIS
-- ══════════════════════════════════════════════════════════════
local Config = {
    DefaultBPM        = 120,
    DefaultSpeed      = 1.0,
    MinSpeed          = 0.25,
    MaxSpeed          = 3.0,
    SpeedStep         = 0.05,
    NightcoreSpeed    = 1.35,
    SlowedSpeed       = 0.75,
    ChordDelay        = 0.02,
    AntiLagThrottle   = 0.003,
    AntiDetectEnabled = true,
    HumanizeMin       = 0.001,
    HumanizeMax       = 0.008,
}

-- ══════════════════════════════════════════════════════════════
--  ESTADO GLOBAL
-- ══════════════════════════════════════════════════════════════
local State = {
    currentSong    = 1,
    isPlaying      = false,
    isPaused       = false,
    speed          = 1.0,
    mode           = "Normal",
    loopEnabled    = false,
    shuffleEnabled = false,
    progress       = 0,
    currentNote    = 0,
    totalNotes     = 0,
    playThread     = nil,
    antiLag        = true,
    humanize       = true,
    customSongs    = {},
    -- V4: Efeitos
    reverbEnabled  = false,
    delayEnabled   = false,
    reverbLevel    = 0.3,
    delayTime      = 0.15,
    -- V4: Dueto
    duetEnabled    = false,
    duetSong2      = 1,
    duetThread     = nil,
    -- V4: Loop de trecho
    loopSectionEnabled = false,
    loopStart      = 0,
    loopEnd        = 100,
    -- V4: Performance
    perfScore      = 0,
    perfNotes      = 0,
    perfAccuracy   = 100,
    -- V4: Código de música
    sharedCode     = "",
}

-- ══════════════════════════════════════════════════════════════
--  MAPA DE TECLAS
-- ══════════════════════════════════════════════════════════════
local KeyMap = {
    ["1"]=Enum.KeyCode.One,   ["2"]=Enum.KeyCode.Two,   ["3"]=Enum.KeyCode.Three,
    ["4"]=Enum.KeyCode.Four,  ["5"]=Enum.KeyCode.Five,  ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight, ["9"]=Enum.KeyCode.Nine,
    ["0"]=Enum.KeyCode.Zero,
    ["!"]=Enum.KeyCode.One,   ["@"]=Enum.KeyCode.Two,   ["#"]=Enum.KeyCode.Three,
    ["$"]=Enum.KeyCode.Four,  ["%"]=Enum.KeyCode.Five,  ["^"]=Enum.KeyCode.Six,
    ["&"]=Enum.KeyCode.Seven, ["*"]=Enum.KeyCode.Eight, ["("]=Enum.KeyCode.Nine,
    [")"]=Enum.KeyCode.Zero,
    ["q"]=Enum.KeyCode.Q,["w"]=Enum.KeyCode.W,["e"]=Enum.KeyCode.E,
    ["r"]=Enum.KeyCode.R,["t"]=Enum.KeyCode.T,["y"]=Enum.KeyCode.Y,
    ["u"]=Enum.KeyCode.U,["i"]=Enum.KeyCode.I,["o"]=Enum.KeyCode.O,
    ["p"]=Enum.KeyCode.P,["a"]=Enum.KeyCode.A,["s"]=Enum.KeyCode.S,
    ["d"]=Enum.KeyCode.D,["f"]=Enum.KeyCode.F,["g"]=Enum.KeyCode.G,
    ["h"]=Enum.KeyCode.H,["j"]=Enum.KeyCode.J,["k"]=Enum.KeyCode.K,
    ["l"]=Enum.KeyCode.L,["z"]=Enum.KeyCode.Z,["x"]=Enum.KeyCode.X,
    ["c"]=Enum.KeyCode.C,["v"]=Enum.KeyCode.V,["b"]=Enum.KeyCode.B,
    ["n"]=Enum.KeyCode.N,["m"]=Enum.KeyCode.M,
    ["Q"]=Enum.KeyCode.Q,["W"]=Enum.KeyCode.W,["E"]=Enum.KeyCode.E,
    ["R"]=Enum.KeyCode.R,["T"]=Enum.KeyCode.T,["Y"]=Enum.KeyCode.Y,
    ["U"]=Enum.KeyCode.U,["I"]=Enum.KeyCode.I,["O"]=Enum.KeyCode.O,
    ["P"]=Enum.KeyCode.P,["A"]=Enum.KeyCode.A,["S"]=Enum.KeyCode.S,
    ["D"]=Enum.KeyCode.D,["F"]=Enum.KeyCode.F,["G"]=Enum.KeyCode.G,
    ["H"]=Enum.KeyCode.H,["J"]=Enum.KeyCode.J,["K"]=Enum.KeyCode.K,
    ["L"]=Enum.KeyCode.L,["Z"]=Enum.KeyCode.Z,["X"]=Enum.KeyCode.X,
    ["C"]=Enum.KeyCode.C,["V"]=Enum.KeyCode.V,["B"]=Enum.KeyCode.B,
    ["N"]=Enum.KeyCode.N,["M"]=Enum.KeyCode.M,
}

local ShiftKeys = {
    Q=true,W=true,E=true,R=true,T=true,Y=true,U=true,I=true,O=true,P=true,
    A=true,S=true,D=true,F=true,G=true,H=true,J=true,K=true,L=true,
    Z=true,X=true,C=true,V=true,B=true,N=true,M=true,
    ["!"]=true,["@"]=true,["#"]=true,["$"]=true,["%"]=true,["^"]=true,
    ["&"]=true,["*"]=true,["("]=true,[")"]=true,
}

-- ══════════════════════════════════════════════════════════════
--  BANCO DE MÚSICAS (100+)
-- ══════════════════════════════════════════════════════════════
local Songs = {}

Songs[1]   = { name="Unravel — Tokyo Ghoul",             bpm=152, emoji="🎭", category="Anime",    sequence="J l-J-j h- l-J-j-h- h g--D D-g d---- d [(d]-d d ( z z- w--w-- J [jq]-j j q J J- 9--9-- J [(^l]-J-[(^j] h- l [9w] J-j [9w] h- h [8gq]--D [8Dq]-g d [^9]--[^9]-- d [(^d]-d d [(^] z z- [9w]--[9w]-- J [8jq]-j j [8q] J J- [5w]---- d-s-P d-s- P [5w][5w] [5w] [5w][5w] [5w][5w] [5w][5w]- [dw]J d[hq] d ( d [9s]d- [dw]J d[hq] d ( J 9j- [dw]J d[hq] d ( d [9s]d- [dw]J d[hq] d ( J Qj- E-w-t E-w- [pt] [Py]-P-[Pt]--P d [dq]-s-s-- P [qs]-P-[pt]-i- y t--E-- i [Ei] y[ey]-[ey] [Et] y[ey]- [ei] [Ei] y[ey]-[ey] [Et] y[ey]- [ei] [Ei] y[ey]-[Ey] [et]-[Ey]- [Ey]--y" }
Songs[2]   = { name="Megalovania — Undertale",            bpm=120, emoji="☠️", category="Games",    sequence="t t d p O o i y i o r r d p O o i y i o E E d p O o i y i o y y d p O o i y i o t t d p O o i y i o r r d p O o i y i o E E d p O o i y i o 9 9 d p O o i y i o 8 8 d p O o i y i o 7 7 d p O o i y i o ^ ^ d p O o i y i o 9 9 d p O o i y i o 8 8 d p O o i y i o 7 7 d p O o i y i o ^ ^ d p O o i y i o [i9] i i i i o i [i8] i i o O o i y i o [i7] i i o O p s p [d^] d d p d s 8 h [p9] p p p p o o [p8] p p p p o d p o [d7] p o y s o i u [y^] u i p s 8" }
Songs[3]   = { name="Cry for Me — The Weeknd",            bpm=106, emoji="💔", category="Pop",      sequence="4 q 4 q 4-q-- 4 q 4 q 4-q-qq [*g] T [*s] T [*P]-TO TT [8f] t [8s] t [8P]-ts tt 4 q 4 q 4-q-- 4 q 4 q 4-q-qq [*g] T [*s] T [*P]-TO TT [8f] t [8s] t 8-t-tt" }
Songs[4]   = { name="Passo Bem Solto — Funk BR",          bpm=128, emoji="🎉", category="Funk",     sequence="a a a S S S d S a I S p p o a a a S S S d S a a a S a a o a S a a a a h G G S o a S a a a a h a [Ga] a [GS] S [dS] d [Sw5] a [I5] G [e6] G [e6] [Su6] [Sr7] a [I7] G [r$] G [r$] [dy$] $ [Sw5] a [I5] G [e6] G [e6] [Su6] [Sr7] a [I7] a [ar$] S [Sr$] [Sy$] [d$]" }
Songs[5]   = { name="Rush E — Sheet Music Boss",          bpm=200, emoji="⚡", category="Meme",     sequence="uuuuuuuuuuuuuuuuuuu6838[u6]838[u6]u[u8]u[u3]u[u8]u[u6]u[u8]u[u3]u[u8]u[u6]u[u8]u[u3]i[u8]Y[u6][p8][s3]8[d%]d[d9]d[d3]s[a9]d[s6]s[s8]s[s3]a[p8]s[a7]a[a(]a[I$][a(][O0][H3]" }
Songs[6]   = { name="Golden Hour — JVKE",                 bpm=97,  emoji="🌅", category="Pop",      sequence="[dq] g h j h f [dq] g h j h f [dq] g h j h f [dq] g h j h f [s0] f h j h f [s0] f h j h f [s0] f h j h f [s(] f h j h f [s9] d g h g d [s9] d g h g d [s9] d g h g d [s9] d g h g d [a8] s d f d s [a8] s d f d s [a8] s d f d s [a8] s d f d s [uq] u u u u y q [uq] u u u u [uq] u u u [u0] u u u u y 0 [u0] u u u [u(] u u u u [y9] t u y u y 9 [u9] y u y u y 9 t [u8] u u u u [u8] u u u u [u8] u u y t 8 u o [p4] u p a s 4 u p a" }
Songs[7]   = { name="Astronomia — Coffin Dance",          bpm=126, emoji="⚰️", category="Meme",     sequence="[6ep] [3ep] [6ep] [6ep] [5ep] [2ep] [5ep] [5ep] [4ep] [1ep] [4ep] [4ep] [3ep] [0ep] [3ep] [3ep] [6ep] [3ep] [6pu] [6pu] [5pu] [2pu] [5pu] [5pu] [4pu] [1pu] [4pu] [4pu] [3pu] [0pu] [3pu] [3pu] [6ep] p [3ep] p [6p] u [6pu] u [5ep] p [2ep] p [5p] u [5pu] u [4ep] p [1ep] p [4p] u [4pu] u [3ep] p [0ep] p [3p] u [3pu] u e p u a s d f [6f]-[3f]-[6f]-[6a]- [5s]-[2s]-[5s]-[5a]- [4p]-[1p]-[4p]-[4o]- [3o]-[0o]-[3o]-[3i]-" }
Songs[8]   = { name="Cruel Summer — Taylor Swift",        bpm=170, emoji="☀️", category="Pop",      sequence="[6u] [6u] [6u] [6y] [6t] [6u] [6u] [6u] [6y] [6t] [8u] [8u] [8u] [8y] [8t] [8u] [8u] [8u] [8y] [8t] [9u] [9u] [9u] [9y] [9t] [9u] [9u] [9u] [9y] [9t] [0u] [0u] [0u] [0y] [0t] [0u] [0u] [0u] [0y] [0t] [6tu] [6tu] [6tu] [6ty] [6yt] [6tu] [6tu] [8tu] [8tu] [8tu] [8ty] [8yt] [8tu] [8tu] [9tu] [9tu] [9tu] [9ry] [9yt] [9tu] [9tu] [0tu] [0tu] [0tu] [0ty] [0yt] [0tu] [0tu]" }
Songs[9]   = { name="River Flows in You — Yiruma",        bpm=72,  emoji="🌊", category="Classica", sequence="[4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [4qp] [qp] [qp] [qp] [4qo] [qo] [qo] [qo] [4qo] [qo] [qo] [qo] [4qi] s d f [4s] s s s [4p] s d f [4p] d s p [4o] p s d [4p] d s p [4i] p s d 4 s d f [4s] d f s [4d] f d s [4p] d s p [4o] s d f [4s] f s d [4d] s p o [4p] o p s" }
Songs[10]  = { name="Happy Birthday — Classico",          bpm=100, emoji="🎂", category="Classica", sequence="s s d s f e s s d s g f s s S h f e t s S h g f d d S f e t [ts] s s s d s f e s s d s g f" }
Songs[11]  = { name="Bad Apple — Touhou",                 bpm=138, emoji="🍎", category="Anime",    sequence="o o i u y t r e w q o o i u y t r e w [wq] [qe] [er] [rt] [ty] [yu] [ui] [io] o i u y t e w q o i u y [ty] t r e w q [qo] [oi] [iu] [uy] [yt] [tr] [re] [ew] [wq] q e r t y u i o o i u y t e w q o i u y t r e w [wq] [qe] [er] [rt] [ty] [yu] [ui] [io] [op] p o i u y t r e [ew] [wq] q w e r t y u i o p [pP] P o i u y t r e w q" }
Songs[12]  = { name="Never Gonna Give You Up — Rick Astley", bpm=113, emoji="🕺", category="Meme",  sequence="ioOissPYioYPPOoiioOiOPoiYYPOioOissPYYYYDoOoiioOiOPoiYYPOioOissPYioYPPOoiioOiOPoiYYPOioOissPYYYYDoOoiioOiOPoiYYPO" }
Songs[13]  = { name="Love Story — Taylor Swift",           bpm=119, emoji="💞", category="Pop",      sequence="[4qet] [4qet] [4qet] [4qet] [4qey] [4qey] [4qey] [4qey] [6qet] [6qet] [6qet] [6qet] [6qey] [6qey] [6qey] [6qey] [5qwt] [5qwt] [5qwt] [5qwt] [5qwy] [5qwy] [5qwy] [5qwy] [3qwt] [3qwt] [3qwt] [3qwt] [3qwy] [3qwy] [3qwy] [3qwy] [4t] e t y t e [4t] e t y u i [6t] e t y t e [6t] e t y u i [5t] w t y t w [5t] w t y u o [3t] w t y t w [3t] w t y u o" }
Songs[14]  = { name="Dance Monkey — Tones and I",          bpm=98,  emoji="🐒", category="Pop",      sequence="[6ep] [6ep] [6ep] [8ep] [9ep] [8ep] [6ep] [6ep] [6ep] [8ep] [9ep] [0ep] [6ep] [6ep] [6ep] [8ep] [9ep] [8ep] [6ep] [6ep] [6ep] [8ep] [9ep] [0ep] p p p [8p] [9p] [8p] p p p [8p] [9p] [0p] p p p [8p] [9p] [8p] p p [op] [8op] [9op] [0op]" }
Songs[15]  = { name="Someone You Loved — Lewis Capaldi",   bpm=109, emoji="🥀", category="Pop",      sequence="[4qi] [4qi] [4qi] [4qi] [4qs] [4qs] [4qs] [4qs] [6qi] [6qi] [6qi] [6qi] [6qp] [6qp] [6qp] [6qp] [5qo] [5qo] [5qo] [5qo] [5qi] [5qi] [5qi] [5qi] [3qu] [3qu] [3qu] [3qu] [3qy] [3qy] [3qy] [3qy] [4i] q i s i q [4i] q i s d f [6i] q i p i q [6i] q i p o u [5o] w o i o w [5o] w o i u y [3u] w u y u w [3u] w u y t e" }
Songs[16]  = { name="Believer — Imagine Dragons",          bpm=125, emoji="💥", category="Rock",     sequence="s s s s s s s [sa] [sa] [sa] [sa] s s s [so] [so] s s [si] [si] s s [sa] [sa] [sa] [sa] [sa] [sa] [sa] [sp] [sp] s s [sa] [sa] [sa] [sa] [sp] [sp] [so] [so] [si] [si] [su] [su] [sy] [sy] [st] [st] [sr] [sr] [se] [se] [sw] [sw] [sq] [sq] s [sa] [sp] [so] [si] [su] [sy] [st] [se] [sq] s s s s [sa] [sa] [sa] [sp] [sp] [so] [so] [si] [si] [su] [su] [sy] [sy]" }
Songs[17]  = { name="Counting Stars — OneRepublic",        bpm=122, emoji="⭐", category="Pop",      sequence="[6eio] [6eio] [6eio] [6eio] [8eio] [8eio] [8eio] [8eio] [9eio] [9eio] [9eio] [9eio] [0eio] [0eio] [0eio] [0eio] [6ei] o i e [6o] i e o [8ei] o i e [8o] i e o [9ei] o i e [9o] i e o [0ei] o i e [0o] i e o i [6o] i e o i e [6o] i o i [8o] i e o i e [8o] i o i [9o] i e o i e [9o] i o i [0o] i e o i e [0o] i o" }
Songs[18]  = { name="Undertale Main Theme",                bpm=95,  emoji="💛", category="Games",    sequence="[4qet] [4qet] [4qet] [qet] [4qey] [qey] [6qet] [6qet] [6qet] [qet] [6qeu] [qeu] [5qwt] [5qwt] [5qwt] [qwt] [5qwy] [qwy] [3qwt] [3qwt] [3qwt] [qwt] [3qwe] [qwe] [4t] e t [qt] y [qt] t [qt] [et] [qt] [4t] e [qt] y u [qu] [qi] [qu] [qy] [qt] [6t] e t [qt] y [qt] t [qt] [et] [qt] [6t] e [qt] y u [qu] [qi] [qu] [qy] [qt]" }
Songs[19]  = { name="STAY — The Kid LAROI & Bieber",       bpm=170, emoji="🌙", category="Pop",      sequence="[6eu] [6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u y t r [0u] e u y u e [0u] e u y t r" }
Songs[20]  = { name="Blinding Lights — The Weeknd",        bpm=171, emoji="🌃", category="Pop",      sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6ep] [8ep] [9ep] [0ep] [6ep] [6epu] [8epu] [9epu] [0epu] [6p] e p u p e [6p] e p u o i [8p] e p u p e [8p] e p u o i [9p] e p u p e [9p] e p u o i [0p] e p u p e [0p] e p u o i" }
Songs[21]  = { name="Fight Back — NEFFEX",                 bpm=150, emoji="👊", category="Rock",     sequence="[6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [9s] e s d f g [0s] e s d s e [0s] e s d f g [6esd] [6esd] [8esd] [8esd] [9esd] [9esd] [0esd] [0esd]" }
Songs[22]  = { name="Ghost — Justin Bieber",               bpm=130, emoji="👻", category="Pop",      sequence="[4qi] [4qi] [qi] [qi] [4qs] [4qs] [qs] [qs] [6qi] [6qi] [qi] [qi] [6qp] [6qp] [qp] [qp] [5qo] [5qo] [qo] [qo] [5qi] [5qi] [qi] [qi] [3qu] [3qu] [qu] [qu] [3qy] [3qy] [qy] [qy] [4i] q [qi] s [qi] q [qi] [qs] [qi] q [4i] q [qi] s [qd] [qf] [qd] [qs] [qi] q [6i] q [qi] p [qi] q [qi] [qp] [qi] q [6i] q [qi] p [qu] [qy] [qu] [qi] [qp] q" }
Songs[23]  = { name="Perfect — Ed Sheeran",                bpm=95,  emoji="💍", category="Pop",      sequence="[4qe] [4qe] [4qe] [qe] [4qr] [qr] [4qt] [qt] [4qr] [qr] [4qe] [qe] [4qw] [qw] [4qq] [4qe] [6qe] [6qe] [6qe] [qe] [6qr] [qr] [6qt] [qt] [6qy] [qy] [6qu] [qu] [6qt] [qt] [6qe] [qe] [5qw] [5qw] [5qw] [qw] [5qe] [qe] [5qr] [qr] [5qt] [qt] [5qr] [qr] [5qe] [qe] [5qw] [qw] [3qw] [3qw] [3qw] [qw] [3qe] [qe] [3qr] [qr] [3qt] [qt] [3qr] [qr] [3qe] [qe] [3qq]" }
Songs[24]  = { name="Skyfall — Adele",                     bpm=76,  emoji="🌧️", category="Pop",     sequence="[6ei] [6ei] [6ei] [6eu] [6ey] [6et] [6ei] [8ei] [8ei] [8ei] [8eu] [8ey] [8et] [8ei] [9ei] [9ei] [9ei] [9eu] [9ey] [9et] [9ei] [0ei] [0ei] [0ei] [0eu] [0ey] [0et] [0ei] [6i] e i u i e [6i] e i u y t [8i] e i u i e [8i] e i u y t [9i] e i u i e [9i] e i u y t [0i] e i u i e [0i] e i u y t" }
Songs[25]  = { name="Demons — Imagine Dragons",            bpm=89,  emoji="😈", category="Rock",     sequence="[4qe] [4qe] [4qr] [4qt] [4qy] [4qu] [4qi] [4qo] [6qe] [6qe] [6qr] [6qt] [6qy] [6qu] [6qi] [6qp] [5qw] [5qw] [5qe] [5qr] [5qt] [5qy] [5qu] [5qi] [3qw] [3qw] [3qe] [3qr] [3qt] [3qy] [3qu] [3qi] [4e] q e r e q [4e] q e r t y [6e] q e r e q [6e] q e r t y [5e] w e r e w [5e] w e r t y [3e] w e r e w [3e] w e r t y" }
Songs[26]  = { name="Song of Storms — Zelda",              bpm=160, emoji="⛈️", category="Games",   sequence="yppuoaissuoayppuoaissuoa[yd]g[pz]p[ud][og][az][ix]sc[sx]c[ux][ol][aj][Ej][pd][pg]h[qj]p[Ej][pd][pg]h[ef]p[yd]g[pz]p[ud][og][az][ix]sc[sx]c[ux][ol][aj][Ej][pd][pg]h[ej]pj[9yd][ip][ip][0u]o[oa]a[qi][ps][ps][0u]o[oa]sapo[29][ip][ip][30]o[oa]a[4q][ps][ps][30]o[oa]a[29y][6i][qed][qe][30y]i[wrd][wr][4qpf]8[et]g[etf]g[30of]s[wrp][wr]" }
Songs[27]  = { name="Zelda's Lullaby",                     bpm=80,  emoji="🧝", category="Games",    sequence="[qf]tp-h-[qd]ya-sd[qf]tp-h-[qd]ya--[0f]od-h-[(z]Is-l-[9h]is-gf[wd]ya-sd[qf]tp-h-[qd]ya--[qf]tp-h-[qd]ya--[0f]od-h-[(z]Is-l-[9v]is--wya-lzxc[Ehv]yip[igc][yfx][egc][tfx][usl]out[wgc]Eyi[yfx][Edz][qfx][edz][tpj]ute" }
Songs[28]  = { name="Minecraft Sweden — C418",             bpm=80,  emoji="🧱", category="Games",    sequence="[29q]-3-[4wt]-6-[50w]-4-[1ry]--[2qe]-3-[4wu]-6-[50r]-4-[1ry]--[2qe]-3-[4wu]-6-[50r]-4-[1ry]--[2qe]-[3o]p[4wu]-6ty[5wr]-4uo[1ry]--[2qe]s[3p]o[4wu]-6ty[5wr]-4ou[1ry]--[2qe]-[3o]p[4ws]-6[tf][yd][5ra]-4sa[1wyo]--[2qe]-[3p]o[4wu]-6ty[5wr]-4uo[1ry]--[2qe]-[3o]p[4wu]-6ty[5wr]-4uo[1ry]--[2qe]-[3o]p[4ws]-6sd[5ra]-[4f]uo[1ry]--[6wu]--po[2eI]-yt[59r]-ty[48e]--[6os]--po[2eI]-y[td][5oa]-s[td]y[4ip]" }
Songs[29]  = { name="Among Us Drip — Amogus",              bpm=120, emoji="📮", category="Meme",     sequence="8sDgGgDsPds58sDgGgDGGgDGgD[8t]sDgGgDsPds5[8t]sDgGgDGGgDGgD[8t]sDgGgDsPds5[8t]sDgGgDG8sDgGgDsPds5[8t]sDgGgDGGgDGgDs[8t]sDgGgDsPds5[8t]sDgGgDGGgDGgD8sDgGgDsPds5[8t]sDgGgDGGgDGgDs" }
Songs[30]  = { name="Bad Habit — Steve Lacy",              bpm=93,  emoji="🎸", category="Pop",      sequence="[il]xcvcaas8ofgh-0-qsfghg[7a]as8ofgh-0-qsfghg[wa]as8fgj-fgh[0j]hqhfj-fghf[7j]h8fgj-fgh[0j]hq-fgjgfg[wj]hqqqqqq8[8s][9d]dddsf-[0d]s-qqqqqq0[8s][9d]dddsf-[0d]s-[qs]fs-fsfss8-[9s]sfsfsfss0-[qj]ssjjss8-[9j]ssjjss0f[9d][8f]8[8g][8h]800q[qs][qf][qg][qh][qg][7a][7a]s8[8o][8f][8g][8h]800q[qs][qf][qg][qh][qg][7a][7a]s" }
Songs[31]  = { name="Erika — German March",                bpm=120, emoji="🌸", category="Classica", sequence="Q--[ow][9e]-[eQ]-[9ep]-y-[9Qy]-I-[9eI]-[9fu][9Qy]-[9ep]-[r9]-[9e]-[9ST]-y-[06fu]-[eQ]-[9r]-[eQ]-[6eI]--[fu][9Qy]-[eQ]-[9r]-[eQ]-Q--[ow][e9]-[Qe]-[9e]-y-[9Qy]-I-[9eI]-[9fu][9Qy]-[e9]-[9r]-[9e]-[ST]-y-[06fu]-[eQ]-[9r]-[eQ]-[6eI]--[fu][9Qy]-[eQ]-[9r]-[eQ]-e--yT6-[0T]-[6T]-[0T]-[6r]-[0T]-[9Qy]-e-r9-e-[ST]--y[6fu]-[0efu]-[6fu]-[0efu]-p-[ho]-[9eI]-e-[9r]-[ep]" }
Songs[32]  = { name="Fur Elise — Beethoven",               bpm=90,  emoji="🎼", category="Classica", sequence="EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtp [0ywq] EwEwEiEwE ypEtu qEtp [0ywq] [3wyo] [5wyi] [6oep] [3wyp] [6oep] [8etp] [0etps] [8etpd] [3wyd] [5wys] [6oep] [3wyp] [4qei] [6etu] [0ety] EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtp [0ywq]" }
Songs[33]  = { name="Ode to Joy — Beethoven",              bpm=116, emoji="🎹", category="Classica", sequence="s s d f f d s p o o p s s- p s s d f f d s p o o p s p p- o p p s o p s p o i o p s p o i u i o p p s d f f d s p o o p s p p" }
Songs[34]  = { name="Moonlight Sonata — Beethoven",        bpm=60,  emoji="🌕", category="Classica", sequence="[3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [3qu] [5qu] [6qu] [3qi] [5qi] [6qi] [3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [2qe] [5qe] [6qe] [2qi] [5qi] [6qi] [2qu] [5qu] [6qu] [2qi] [5qi] [6qi] [1qe] [4qe] [6qe] [1qi] [4qi] [6qi] [1qu] [4qu] [6qu] [1qi] [4qi] [6qi] [1qr] [4qr] [5qr] [1qt] [4qt] [5qt] [1qy] [4qy] [5qy] [0qe] [4qe] [6qe] [0qi] [4qi] [6qi] [3qe] [5qe] [6qe] [3qi] [5qi] [6qi]" }
Songs[35]  = { name="Despacito — Luis Fonsi",              bpm=89,  emoji="💃", category="Pop",      sequence="p p o i u y [6u] u o p o i [8u] u o p s d [9f] f d s p o [0p] o i u y t [6u] u o p o i [8u] u o p s d [9f] f d s d f [0g] g f d s p p p o i u y [6u] u u o p o i [8u] u u o p s d [9f] f f d s p o [0p] o o i u y t [6u] o p s d f [8g] f d s p o [9i] o p s d f [0g] f d p o i u" }
Songs[36]  = { name="Shape of You — Ed Sheeran",           bpm=96,  emoji="❤️", category="Pop",      sequence="[6ei] i i i [6ei] i [8ei] i i i [8ei] i [9ei] i i i [9ei] i [0ei] i i i [0ei] i [6eu] u u u [6eu] u [8eu] u u u [8eu] u [9eu] u u u [9eu] u [0eu] u u u [0eu] u [6eio] [8eio] [9eio] [0eio] [6eio] [8eio] [9eio] [0eio] [6eiop] i e [8eiop] i e [9eiop] i e [0eiop] i e [6i] i o p i o [8i] i o p i o [9i] i o p i o [0i] i o p i o" }
Songs[37]  = { name="Sunflower — Post Malone",             bpm=90,  emoji="🌻", category="Pop",      sequence="[4qi] [4qi] [4qi] [4qs] [4qd] [4qf] [6qi] [6qi] [6qi] [6qs] [6qd] [6qf] [5qo] [5qo] [5qo] [5qi] [5qu] [5qy] [3qu] [3qu] [3qu] [3qy] [3qt] [3qe] [4i] q i s d f [4s] d s d s p [6i] q i s d f [6s] d f d s p [5o] w o i u y [5u] y u y u t [3u] w u y t e [3t] e t e t r i [qi] [qs] [qd] [qf] [qd] [qs] [qi] [qo] [qu] [qy] [qt] [qe] [qw] [qq]" }
Songs[38]  = { name="Old Town Road — Lil Nas X",           bpm=136, emoji="🤠", category="Pop",      sequence="[6e] s d f d s [6e] p o i o p [8e] s d f d s [8e] p o i u y [9e] s d f d s [9e] p o i o p [0e] s d f d s [0e] p o i u y [6es] [6es] [6ed] [6ef] [8es] [8es] [8ep] [8eo] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ep] [0eo]" }
Songs[39]  = { name="Take On Me — a-ha",                   bpm=169, emoji="📻", category="Pop",      sequence="[6ei] [ei] [6eo] [eo] [6ep] [ep] [8ei] [ei] [8eo] [eo] [8ep] [ep] [9ei] [ei] [9eo] [eo] [9ep] [ep] [0ei] [ei] [0eo] [eo] [0ep] [ep] [6i] e i o i e [6p] o i u i o [8i] e i o i e [8p] o i u y t [9i] e i o i e [9p] o i u i o [0i] e i o i e [0p] o i u y t" }
Songs[40]  = { name="Bohemian Rhapsody — Queen",           bpm=72,  emoji="👑", category="Rock",     sequence="[6ep] p [ep] u [6eu] [8ep] p [ep] u [8eu] [9ep] p [ep] u [9eu] [0ep] p [ep] o [0eo] [6p] e p u p e [6u] t u y u t [8p] e p u p e [8u] t u y u t [9p] e p u p e [9u] t u y u t [0o] e o i o e [0i] t i u i t" }
Songs[41]  = { name="September — Earth Wind & Fire",       bpm=126, emoji="🍂", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u y t r [0u] e u y u e [0u] e u y t r" }
Songs[42]  = { name="Uptown Funk — Bruno Mars",            bpm=115, emoji="🕶️", category="Pop",     sequence="[6es] s [es] d [6ed] [8es] s [es] d [8ed] [9es] s [es] d [9ed] [0es] s [es] d [0ed] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [9s] e s d f g [0s] e s d s e [0s] e s d f g" }
Songs[43]  = { name="Happy — Pharrell Williams",           bpm=160, emoji="😊", category="Pop",      sequence="[6eu] [eu] [6ey] [ey] [6et] [et] [6er] [er] [8eu] [eu] [8ey] [ey] [8et] [et] [8er] [er] [9eu] [eu] [9ey] [ey] [9et] [et] [9er] [er] [0eu] [eu] [0ey] [ey] [0et] [et] [0er] [er]" }
Songs[44]  = { name="Can't Stop The Feeling — JT",         bpm=113, emoji="🎤", category="Pop",      sequence="[6eiu] [6eiu] [6eiy] [6eit] [8eiu] [8eiu] [8eiy] [8eit] [9eiu] [9eiu] [9eiy] [9eit] [0eiu] [0eiu] [0eiy] [0eit] [6i] e i u y u [6i] e i y t r [8i] e i u y u [8i] e i y t r [9i] e i u y u [9i] e i y t r [0i] e i u y u [0i] e i y t r" }
Songs[45]  = { name="Feel Good Inc — Gorillaz",            bpm=138, emoji="🎮", category="Rock",     sequence="[6es] [6es] [6ep] [6eo] [8es] [8es] [8ep] [8eo] [9es] [9es] [9ep] [9eo] [0es] [0es] [0ep] [0eo] [6s] e s p s e [6s] e s p o i [8s] e s p s e [8s] e s p o i [9s] e s p s e [9s] e s p o i [0s] e s p s e [0s] e s p o i" }
Songs[46]  = { name="Smells Like Teen Spirit — Nirvana",   bpm=117, emoji="🎸", category="Rock",     sequence="[6ea] [6ea] [6ea] [6ea] [8ea] [8ea] [8ea] [8ea] [9ea] [9ea] [9ea] [9ea] [0ea] [0ea] [0ea] [0ea] [6a] e a s a e [6a] e a s d f [8a] e a s a e [8a] e a s d f [9a] e a s a e [9a] e a s d f [0a] e a s a e [0a] e a s d f" }
Songs[47]  = { name="Thunder — Imagine Dragons",           bpm=168, emoji="⚡", category="Rock",     sequence="[6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [9p] e p o i u [0p] e p o p e [0p] e p o i u" }
Songs[48]  = { name="Levitating — Dua Lipa",               bpm=103, emoji="🪐", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i e [6i] e i u y t [8i] e i u i e [8i] e i u y t [9i] e i u i e [9i] e i u y t [0i] e i u i e [0i] e i u y t" }
Songs[49]  = { name="As It Was — Harry Styles",            bpm=174, emoji="🪩", category="Pop",      sequence="[6eu] [eu] [6ey] [ey] [6et] [et] [8eu] [eu] [8ey] [ey] [8et] [et] [9eu] [eu] [9ey] [ey] [9et] [et] [0eu] [eu] [0ey] [ey] [0et] [et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u y t r [0u] e u y u e [0u] e u y t r" }
Songs[50]  = { name="Flowers — Miley Cyrus",               bpm=118, emoji="💐", category="Pop",      sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [6i] q i p o u [5o] w o i u y [5o] w o i u t [3u] w u y t e [3u] w u y t r" }
Songs[51]  = { name="Anti-Hero — Taylor Swift",            bpm=97,  emoji="🦸", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [9u] e u y i o [0u] e u y t e [0u] e u y i o" }
Songs[52]  = { name="Yellow — Coldplay",                   bpm=88,  emoji="💛", category="Rock",     sequence="[4qe] [4qe] [4qr] [4qt] [4qy] [6qe] [6qe] [6qr] [6qt] [6qu] [5qw] [5qw] [5qe] [5qr] [5qt] [3qw] [3qw] [3qe] [3qr] [3qt] [4e] q e t e q [4e] q e t y u [6e] q e t e q [6e] q e t y u [5e] w e t e w [5e] w e t y u [3e] w e t e w [3e] w e t y u" }
Songs[53]  = { name="The Scientist — Coldplay",            bpm=76,  emoji="🔬", category="Rock",     sequence="[4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [6qi] [qi] [qi] [qi] [6qo] [qo] [qo] [qo] [5qo] [qo] [qo] [qo] [5qi] [qi] [qi] [qi] [3qu] [qu] [qu] [qu] [3qy] [qy] [qy] [qy] [4i] q i p i q [4p] o i u i o [6i] q i p i q [6i] q i o u y [5o] w o i o w [5o] w o i u y [3u] w u y u w [3u] w u y t e" }
Songs[54]  = { name="Fix You — Coldplay",                  bpm=70,  emoji="✨", category="Rock",     sequence="[4qe] [4qe] [4qe] [4qe] [4qr] [4qr] [4qt] [4qt] [6qe] [6qe] [6qe] [6qe] [6qr] [6qr] [6qt] [6qt] [5qw] [5qw] [5qw] [5qw] [5qe] [5qe] [5qr] [5qr] [3qw] [3qw] [3qw] [3qw] [3qe] [3qe] [3qr] [3qr]" }
Songs[55]  = { name="My Heart Will Go On — Celine Dion",   bpm=60,  emoji="🚢", category="Classica", sequence="[4qi] [qi] [qs] [qd] [4qf] [qf] [qd] [qs] [6qi] [qi] [qp] [qo] [6qi] [qi] [qo] [qu] [5qo] [qo] [qi] [qu] [5qy] [qy] [qt] [qe] [3qu] [qu] [qy] [qt] [3qe] [qe] [qr] [qt] [4i] q i s d f [4f] d s d s p [6i] q i p o u [6y] u y u t e [5o] w o i u y [3u] w u y t e" }
Songs[56]  = { name="All of Me — John Legend",             bpm=63,  emoji="🎹", category="Pop",      sequence="[4qi] [4qi] [4qs] [4qd] [6qs] [6qs] [6qd] [6qf] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i s d f [4d] s p o p s [6s] q s d f g [6f] d s p o i [5o] w o i u y [3u] w u y t e" }
Songs[57]  = { name="Titanium — David Guetta",             bpm=126, emoji="🔩", category="EDM",      sequence="[6ep] [6ep] [6ep] [6eo] [8ep] [8ep] [8ep] [8eo] [9ep] [9ep] [9ep] [9eo] [0ep] [0ep] [0ep] [0eo] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [9p] e p o i u [0p] e p o p e [0p] e p o i u" }
Songs[58]  = { name="Faded — Alan Walker",                 bpm=90,  emoji="🌫️", category="EDM",     sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i e [6i] e i u y t [8i] e i u i e [8i] e i u y t [9i] e i u i e [9i] e i u y t [0i] e i u i e [0i] e i u y t" }
Songs[59]  = { name="Alone — Marshmello",                  bpm=100, emoji="🎭", category="EDM",      sequence="[6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [9p] e p o i u [0p] e p o p e [0p] e p o i u" }
Songs[60]  = { name="Giorno's Theme — JoJo",               bpm=130, emoji="⭐", category="Anime",    sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ed] [0ef] [6s] e s d f d [6s] e s d f g [8s] e s d f d [8s] e s d f g [9s] e s d f d [9s] e s d f g [0s] e s d f d [0s] e s d f g" }
Songs[61]  = { name="Gurenge — Demon Slayer",              bpm=135, emoji="🔥", category="Anime",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [9u] e u y i o [0u] e u y t e [0u] e u y i o" }
Songs[62]  = { name="Blue Bird — Naruto",                  bpm=150, emoji="🐦", category="Anime",    sequence="[6ei] [ei] [6eo] [eo] [6ep] [ep] [8ei] [ei] [8eo] [eo] [8ep] [ep] [9ei] [ei] [9eo] [eo] [9ep] [ep] [0ei] [ei] [0eo] [eo] [0ep] [ep] [6i] e i o p o [8i] e i o p o [9i] e i o p o [0i] e i o p o" }
Songs[63]  = { name="Zankyou Sanka — Demon Slayer S2",     bpm=165, emoji="🌊", category="Anime",    sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p u o i [8p] e p o p e [8p] e p u o i [9p] e p o p e [9p] e p u o i [0p] e p o p e [0p] e p u o i" }
Songs[64]  = { name="Shinzou wo Sasageyo — AoT",           bpm=160, emoji="⚔️", category="Anime",   sequence="[6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [9s] e s d f g [0s] e s d s e [0s] e s d f g" }
Songs[65]  = { name="Silhouette — Naruto",                 bpm=145, emoji="🥷", category="Anime",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u y t r [0u] e u y u e [0u] e u y t r" }
Songs[66]  = { name="Sparkle — Your Name",                 bpm=80,  emoji="✨", category="Anime",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [6i] q i p o u [5o] w o i u y [3u] w u y t e" }
Songs[67]  = { name="One Summer's Day — Spirited Away",    bpm=55,  emoji="🌸", category="Anime",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [5o] w o i u y [3u] w u y t e" }
Songs[68]  = { name="Merry Go Round — Howl's Castle",      bpm=90,  emoji="🏰", category="Anime",    sequence="[4qi] [qi] [qs] [qd] [4qf] [qf] [qd] [qs] [6qi] [qi] [qp] [qo] [6qi] [qi] [qo] [qu] [5qo] [qo] [qi] [qu] [5qy] [qy] [qt] [qe] [3qu] [qu] [qy] [qt] [3qe] [qe] [qr] [qt]" }
Songs[69]  = { name="Cruel Angel Thesis — Evangelion",     bpm=128, emoji="🤖", category="Anime",    sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p u o i [8p] e p o p e [8p] e p u o i [9p] e p o p e [0p] e p u o i" }
Songs[70]  = { name="Suzume — RADWIMPS",                   bpm=120, emoji="🚪", category="Anime",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [6i] q i p o u" }
Songs[71]  = { name="JJK OP — Kaikai Kitan",               bpm=145, emoji="👁️", category="Anime",   sequence="[6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [0s] e s d f g" }
Songs[72]  = { name="Chainsaw Man OP — KICK BACK",         bpm=150, emoji="🪚", category="Anime",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [8u] e u y u e [9u] e u y u e [0u] e u y u e" }
Songs[73]  = { name="Still D.R.E. — Dr. Dre",              bpm=93,  emoji="🎤", category="Hip-Hop",  sequence="[6ei] [6ei] [6ei] [6ei] [8ei] [8ei] [8ei] [8ei] [9ei] [9ei] [9ei] [9ei] [0ei] [0ei] [0ei] [0ei] [6i] e i i e i [8i] e i i e i [9i] e i i e i [0i] e i i e i" }
Songs[74]  = { name="Lose Yourself — Eminem",              bpm=87,  emoji="🎤", category="Hip-Hop",  sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ed] [0ef] [6s] e s d f d [6s] e s d f g [8s] e s d f d [8s] e s d f g [9s] e s d f d [0s] e s d f g" }
Songs[75]  = { name="Phonk — MURDER IN MY MIND",           bpm=140, emoji="💀", category="Hip-Hop",  sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ed] [0ef] [6s] e s d f g [8s] e s d f g [9s] e s d f g [0s] e s d f g" }
Songs[76]  = { name="Industry Baby — Lil Nas X",           bpm=150, emoji="🏭", category="Hip-Hop",  sequence="[6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [0p] e p o i u" }
Songs[77]  = { name="Montero — Lil Nas X",                 bpm=110, emoji="😈", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [8u] e u y t e [9u] e u y t e [0u] e u y t e" }
Songs[78]  = { name="Vampire — Olivia Rodrigo",            bpm=138, emoji="🧛", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [0u] e u y i o" }
Songs[79]  = { name="Greedy — Tate McRae",                 bpm=110, emoji="💅", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i e [6i] e i u y t [8i] e i u i e [8i] e i u y t [9i] e i u i e [0i] e i u y t" }
Songs[80]  = { name="Bloody Mary — Lady Gaga",             bpm=130, emoji="🩸", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i e [8i] e i u i e [9i] e i u i e [0i] e i u i e" }
Songs[81]  = { name="Heat Waves — Glass Animals",          bpm=80,  emoji="🌡️", category="Indie",   sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [6i] q i o p o [5o] w o i u y [3u] w u y t e" }
Songs[82]  = { name="Heather — Conan Gray",                bpm=102, emoji="💜", category="Indie",    sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u y t [8i] e i u y t [9i] e i u y t [0i] e i u y t" }
Songs[83]  = { name="Cupid — FIFTY FIFTY",                 bpm=100, emoji="💘", category="K-Pop",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [0u] e u y t r" }
Songs[84]  = { name="Interstellar Theme — Hans Zimmer",    bpm=55,  emoji="🚀", category="Classica", sequence="[4qe] [4qe] [4qe] [4qe] [4qr] [4qr] [4qt] [4qt] [6qe] [6qe] [6qe] [6qe] [6qr] [6qr] [6qt] [6qt] [5qw] [5qw] [5qw] [5qw] [5qe] [5qe] [5qr] [5qr] [3qw] [3qw] [3qw] [3qw] [3qe] [3qe] [3qr] [3qr]" }
Songs[85]  = { name="Canon in D — Pachelbel",              bpm=65,  emoji="🎻", category="Classica", sequence="[4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [6qi] [qi] [qi] [qi] [6qo] [qo] [qo] [qo] [5qo] [qo] [qo] [qo] [5qi] [qi] [qi] [qi] [3qu] [qu] [qu] [qu] [3qy] [qy] [qy] [qy] [4i] q i p i q [4p] o i u i o [6i] q i p i q [6i] q i o u y [5o] w o i o w [5o] w o i u y [3u] w u y u w [3u] w u y t e" }
Songs[86]  = { name="Nocturne Op.9 No.2 — Chopin",         bpm=50,  emoji="🌙", category="Classica", sequence="[3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [3qu] [5qu] [6qu] [3qi] [5qi] [6qi] [3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [2qe] [5qe] [6qe] [2qi] [5qi] [6qi] [1qe] [4qe] [6qe] [1qi] [4qi] [6qi]" }
Songs[87]  = { name="Nuvole Bianche — Einaudi",            bpm=65,  emoji="☁️", category="Classica", sequence="[4qi] [4qi] [4qs] [4qd] [6qs] [6qs] [6qd] [6qf] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i s d f [4d] s p o p s [6s] q s d f g [5o] w o i u y [3u] w u y t e" }
Songs[88]  = { name="Married Life — UP",                   bpm=75,  emoji="🎈", category="Classica", sequence="[4qe] [4qe] [4qe] [4qe] [4qr] [4qr] [4qt] [4qt] [6qe] [6qe] [6qe] [6qe] [6qr] [6qr] [6qt] [6qt] [5qw] [5qw] [5qw] [5qw] [5qe] [5qe] [5qr] [5qr] [3qw] [3qw] [3qw] [3qw] [3qe] [3qe] [3qr] [3qr]" }
Songs[89]  = { name="Wet Hands — Minecraft",               bpm=70,  emoji="🧱", category="Games",    sequence="[4qe] [4qe] [4qr] [4qt] [6qe] [6qe] [6qr] [6qt] [5qw] [5qw] [5qe] [5qr] [3qw] [3qw] [3qe] [3qr] [4e] q e r t y [6e] q e r t y [5e] w e r t y [3e] w e r t y" }
Songs[90]  = { name="Pigstep — Minecraft",                 bpm=110, emoji="🐷", category="Games",    sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i e [6i] e i u y t [8i] e i u i e [8i] e i u y t [9i] e i u i e [0i] e i u y t" }
Songs[91]  = { name="His Theme — Undertale",               bpm=75,  emoji="💛", category="Games",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [5o] w o i u y [3u] w u y t e" }
Songs[92]  = { name="Hopes and Dreams — Undertale",        bpm=140, emoji="⭐", category="Games",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [0u] e u y i o" }
Songs[93]  = { name="Bury the Light — DMC5",               bpm=155, emoji="⚔️", category="Games",   sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p u o i [8p] e p o p e [8p] e p u o i [9p] e p o p e [0p] e p u o i" }
Songs[94]  = { name="Baile de Favela — MC Joao",           bpm=130, emoji="🎉", category="Funk",     sequence="a a a S S S d S a I S p p o a a a S S S d S a a a S a a o a S a a a a h G G S o a S a a a a h a" }
Songs[95]  = { name="Ai Se Eu Te Pego — Michel Telo",      bpm=128, emoji="💃", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [0u] e u y t r" }
Songs[96]  = { name="Snowman — Sia",                       bpm=90,  emoji="⛄", category="Pop",      sequence="[4qe] [4qe] [4qr] [4qt] [6qe] [6qe] [6qr] [6qt] [5qw] [5qw] [5qe] [5qr] [3qw] [3qw] [3qe] [3qr] [4e] q e r t y [6e] q e r t y [5e] w e r t y [3e] w e r t y" }
Songs[97]  = { name="Paint The Town Red — Doja Cat",       bpm=100, emoji="🎨", category="Pop",      sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ed] [0ef] [6s] e s d f d [6s] e s d f g [8s] e s d f d [8s] e s d f g" }
Songs[98]  = { name="Homage — Mild High Club",             bpm=95,  emoji="🎵", category="Indie",    sequence="[4qe] [4qe] [4qr] [4qt] [6qe] [6qe] [6qr] [6qt] [5qw] [5qw] [5qe] [5qr] [3qw] [3qw] [3qe] [3qr] [4e] q e r t y [6e] q e r t y [5e] w e r t y [3e] w e r t y" }
Songs[99]  = { name="Bury A Friend — Billie Eilish",       bpm=111, emoji="🖤", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [8u] e u y t e [9u] e u y t e [0u] e u y t e" }
Songs[100] = { name="Enemy — Imagine Dragons",             bpm=115, emoji="⚡", category="Rock",     sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [0p] e p o i u" }

-- ══════════════════════════════════════════
--  NOVAS MÚSICAS V4 (101–130)
-- ══════════════════════════════════════════
Songs[101] = { name="Calm Down — Rema & Selena",           bpm=106, emoji="🌴", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u y t [6i] e i u y i [8i] e i u y t [8i] e i u i o [9i] e i u y t [9i] e i u y i [0i] e i u t e [0i] e i u y t" }
Songs[102] = { name="Shakira — Bzrp Session 53",           bpm=128, emoji="💃", category="Pop",      sequence="[6es] [6es] [6ed] [6es] [8es] [8ed] [8ef] [8ed] [9es] [9es] [9ed] [9es] [0ed] [0ef] [0eg] [0ef] [6s] e s d s p [6s] e s p o i [8s] e s d s p [8s] e s p o u [9s] e s d f d [9s] e s d f g [0d] e d f g f [0d] e d f d s" }
Songs[103] = { name="Cruel Summer — Acoustic Ver.",        bpm=95,  emoji="🎸", category="Indie",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p s [4p] o i u i o [6i] q i o p s [6p] o i u y t [5o] w o i u y [5u] y u y u t [3u] w u y t e [3t] e t e t r" }
Songs[104] = { name="Essence — Wizkid",                    bpm=95,  emoji="🌟", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6y] t u y i u [8u] e u y t e [8y] t u y i o [9u] e u y t e [9y] t u y i u [0u] e u y t e [0y] t y u i o" }
Songs[105] = { name="Peaches — Justin Bieber",             bpm=98,  emoji="🍑", category="Pop",      sequence="[4qi] [4qi] [4qs] [4qd] [6qi] [6qi] [6qs] [6qd] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qi] [3qy] [4i] q i s d s [4i] q i s d f [6i] q i s d s [6i] q i s p o [5o] w o i u y [5o] w o u y t [3u] w u y i y [3u] w u y t r" }
Songs[106] = { name="STAY — Acoustic Piano",               bpm=80,  emoji="🎹", category="Classica", sequence="[4qi] [qi] [qi] [qi] [4qs] [qs] [4qd] [qd] [6qi] [qi] [qi] [qi] [6qp] [qp] [6qo] [qo] [5qo] [qo] [5qi] [qi] [5qu] [qu] [5qy] [qy] [3qu] [qu] [3qy] [qy] [3qt] [qt] [3qe] [qe] [4i] q i s d s [4d] s p o p s [6i] q i p o u [5o] w o i u y [3u] w u y t e" }
Songs[107] = { name="Lavender Haze — Taylor Swift",        bpm=95,  emoji="💜", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u i o p [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u i o p [0u] e u y u e [0u] e u y t r" }
Songs[108] = { name="Miley Cyrus — Flowers (Slow)",        bpm=72,  emoji="🌸", category="Classica", sequence="[4qi] [qi] [qi] [qi] [4qp] [qp] [4qs] [qs] [6qi] [qi] [qi] [qi] [6qo] [qo] [6qu] [qu] [5qo] [qo] [5qi] [qi] [5qu] [qu] [5qy] [qy] [3qu] [qu] [3qt] [qt] [3qe] [qe] [3qw] [qw] [4i] q i p s p [4s] d s p o i [6i] q i p o u [6y] u y t e t [5o] w o i u y [3u] w u y t e" }
Songs[109] = { name="Escapism — RAYE",                     bpm=105, emoji="🚀", category="Pop",      sequence="[6es] [6es] [6ep] [6eo] [8es] [8es] [8ep] [8eo] [9es] [9es] [9ep] [9eo] [0es] [0es] [0ep] [0eo] [6s] e s p o p [6s] e s p i u [8s] e s p o p [8s] e s p i o [9s] e s p o p [9s] e s p i u [0s] e s p o p [0s] e s o i u" }
Songs[110] = { name="Popular — The Weeknd",                bpm=105, emoji="👑", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u i o [6i] e i u y t [8i] e i u i o [8i] e i u y t [9i] e i u i o [9i] e i u y t [0i] e i u i o [0i] e i u y t" }
Songs[111] = { name="Starboy — The Weeknd",                bpm=186, emoji="⭐", category="Pop",      sequence="[6eu] [eu] [6ey] [ey] [6et] [8eu] [eu] [8ey] [ey] [8et] [9eu] [eu] [9ey] [ey] [9et] [0eu] [eu] [0ey] [ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [0u] e u y t e" }
Songs[112] = { name="Superhero — Metro Boomin",            bpm=140, emoji="🦸", category="Hip-Hop",  sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9ed] [9ef] [9eg] [0es] [0es] [0ed] [0ef] [6s] e s d f g [6g] f d s p o [8s] e s d f g [8g] f d s p o [9s] e s d f g [9g] f d s p o [0s] e s d f g [0g] f d s p o" }
Songs[113] = { name="Creepin' — Metro Boomin",             bpm=100, emoji="👻", category="Hip-Hop",  sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p u o i [6p] e p u y t [8p] e p u o i [8p] e p u y t [9p] e p u o i [9p] e p u y t [0p] e p u o i [0p] e p u y t" }
Songs[114] = { name="Tití Me Preguntó — Bad Bunny",        bpm=104, emoji="🐰", category="Pop",      sequence="[6eu] [eu] [6ey] [ey] [6eu] [8eu] [eu] [8ey] [ey] [8eu] [9eu] [eu] [9ey] [ey] [9eu] [0eu] [eu] [0ey] [ey] [0eu] [6u] e u i o p [6u] e u y t r [8u] e u i o p [8u] e u y t r [9u] e u i o p [0u] e u y t r" }
Songs[115] = { name="Ella Baila Sola — Eslabon",           bpm=75,  emoji="🌙", category="Pop",      sequence="[4qi] [qi] [qi] [qi] [4qs] [qs] [qs] [qs] [6qi] [qi] [qi] [qi] [6qo] [qo] [qo] [qo] [5qo] [qo] [qo] [qo] [5qi] [qi] [qi] [qi] [3qu] [qu] [qu] [qu] [3qy] [qy] [qy] [qy] [4i] q i s d s [4i] q i s p o [6i] q i p o i [6o] u o i p s [5o] w o i u y [3u] w u y t e" }
Songs[116] = { name="La Bachata — Manuel Turizo",          bpm=89,  emoji="🎶", category="Pop",      sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u y i [6u] y i u o u [8i] e i u y i [8u] y i u o u [9i] e i u y i [9u] y i u o u [0i] e i u y i [0u] y i u t r" }
Songs[117] = { name="Quevedo — Bzrp Session 52",           bpm=126, emoji="🔥", category="Pop",      sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p u o i [6o] i p u y t [8p] e p u o i [8o] i p u y t [9p] e p u o i [9o] i p u y t [0p] e p u o i [0o] i p u y t" }
Songs[118] = { name="Despecha — Rosalia",                  bpm=118, emoji="💫", category="Pop",      sequence="[6eu] [eu] [6ey] [ey] [6et] [et] [8eu] [eu] [8ey] [ey] [8et] [et] [9eu] [eu] [9ey] [ey] [9et] [et] [0eu] [eu] [0ey] [ey] [0et] [et] [6u] e u y t r [6u] e u y i u [8u] e u y t r [8u] e u y i u [9u] e u y t r [0u] e u y t r" }
Songs[119] = { name="Seven — BTS Jungkook",                bpm=117, emoji="7️⃣", category="K-Pop",   sequence="[6ei] [6ei] [6eu] [6ey] [8ei] [8ei] [8eu] [8ey] [9ei] [9ei] [9eu] [9ey] [0ei] [0ei] [0eu] [0ey] [6i] e i u y t [6i] e i u i o [8i] e i u y t [8i] e i u i o [9i] e i u y t [9i] e i u i o [0i] e i u y t [0i] e i u t r" }
Songs[120] = { name="Queencard — (G)I-DLE",                bpm=115, emoji="♛", category="K-Pop",    sequence="[6es] [6es] [6ed] [6es] [8es] [8es] [8ed] [8es] [9es] [9ed] [9ef] [9es] [0es] [0es] [0ed] [0es] [6s] e s d s p [6s] e s p o i [8s] e s d s p [8s] e s p o u [9s] e s d s p [9s] e s p o i [0s] e s d s p [0s] e s p o u" }
Songs[121] = { name="Hype Boy — NewJeans",                 bpm=142, emoji="👟", category="K-Pop",    sequence="[6eu] [eu] [6ey] [ey] [6eu] [8eu] [eu] [8ey] [ey] [8eu] [9eu] [eu] [9ey] [ey] [9eu] [0eu] [eu] [0ey] [ey] [0eu] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [0u] e u y t e" }
Songs[122] = { name="OMG — NewJeans",                      bpm=115, emoji="😮", category="K-Pop",    sequence="[6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p u o i [6p] e p u y t [8p] e p u o i [8p] e p u y t [9p] e p u o i [9p] e p u y t [0p] e p u o i [0p] e p u y t" }
Songs[123] = { name="Super — EXO (Xiumin solo)",           bpm=108, emoji="💥", category="K-Pop",    sequence="[6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d f d [6s] e s d f g [8s] e s d f d [8s] e s d f g [9s] e s d f d [0s] e s d f g" }
Songs[124] = { name="Shivers — Ed Sheeran",                bpm=98,  emoji="🥶", category="Pop",      sequence="[4qi] [4qi] [4qs] [4qd] [6qi] [6qi] [6qp] [6qo] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i s d f [4d] s p o p s [6i] q i p o u [6y] u y t e t [5o] w o i u y [5u] y u y u t [3u] w u y t e [3t] e t e r e" }
Songs[125] = { name="Overpass Graffiti — Ed Sheeran",      bpm=115, emoji="🎨", category="Pop",      sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y u e [6u] e u y t r [8u] e u y u e [8u] e u y t r [9u] e u y u e [9u] e u y t r [0u] e u y u e [0u] e u y t r" }
Songs[126] = { name="Love Me Again — John Newman",          bpm=112, emoji="❤️‍🔥", category="Pop",   sequence="[6es] [6es] [6ed] [6ef] [8es] [8es] [8ed] [8ef] [9es] [9es] [9ed] [9ef] [0es] [0es] [0ed] [0ef] [6s] e s d f d [6s] e s d f g [8s] e s d f d [8s] e s d f g [9s] e s d f d [9s] e s d f g [0s] e s d f d [0s] e s d f g" }
Songs[127] = { name="Proposta — Jorge & Mateus",            bpm=90,  emoji="💍", category="Sertanejo", sequence="[4qi] [4qi] [4qi] [4qs] [4qd] [6qi] [6qi] [6qp] [6qo] [6qu] [5qo] [5qo] [5qi] [5qu] [5qy] [3qu] [3qu] [3qy] [3qt] [3qe] [4i] q i s d s [4i] q i p o i [6i] q i p o u [6y] u y t e t [5o] w o i u y [3u] w u y t e" }
Songs[128] = { name="Arrocha do Coração — João Gomes",      bpm=98,  emoji="🤠", category="Sertanejo", sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [0u] e u y t e" }
Songs[129] = { name="Relicário — Gustavo Mioto",            bpm=85,  emoji="📿", category="Sertanejo", sequence="[4qi] [qi] [qi] [qi] [4qp] [qp] [4qs] [qs] [6qi] [qi] [6qo] [qo] [6qu] [qu] [6qy] [qy] [5qo] [qo] [5qi] [qi] [5qu] [qu] [3qy] [qy] [3qu] [qu] [3qt] [qt] [4i] q i p s d [4d] s p o p s [6i] q i p o u [5o] w o i u y [3u] w u y t e" }
Songs[130] = { name="Tocando Em Frente — Almir Sater",      bpm=72,  emoji="🌄", category="Sertanejo", sequence="[4qi] [qi] [qs] [qd] [4qf] [qf] [qd] [qs] [6qi] [qi] [qp] [qo] [6qi] [qi] [qo] [qu] [5qo] [qo] [qi] [qu] [5qy] [qy] [qt] [qe] [3qu] [qu] [qy] [qt] [3qe] [qe] [qr] [qt] [4i] q i s d f [4f] d s d s p [6i] q i p o u [5o] w o i u y [3u] w u y t e" }

-- ══════════════════════════════════════════════════════════════
--  MÚSICAS DO TALENTLESS ORIGINAL (131+)
-- ══════════════════════════════════════════════════════════════
Songs[131] = { name="2 Phút Hơn — Phao & Masew",  bpm=128, emoji="🇻🇳", category="Pop", sequence="[u3] - - I - - o - - d - - [a5] - - p - - o - - - - [u1] - - I - - o - - d - - [a7] - - p - - o - - - - [u307] - - [30] [I37] - [30] - [o37] - [30] - [d370] - [370] - [a5w9] - - [5w] [p59] - [5w] - [o59] - [5w] - [59] - [59w] - [u185] - - [18] [I15] - [18] - [o15] - [18] - [d158] - [158] [158] [a7$7] - - [p7$7] - - [o7$] - 7 - [u7$7] - [7$7] - [u370] - a [30] o - [I30] - u - [a30] - [o30] [30] [I30] - [u59w] - a [5w] o - [I5w] - s - [a5w] - [o5w] - [t5w] - [u158] - a [18] o - [I18] - u - [a18] - [o18] - [I18] [18] [u7$] - a 7 [o7$] - [I7] - [t7$] - [r7] - [w7$7] - [7$7] -" }

local TOTAL_SONGS = #Songs

-- ══════════════════════════════════════════════════════════════
--  PERSISTÊNCIA (Custom Songs)
-- ══════════════════════════════════════════════════════════════
local SAVE_FILE = "TalentlessV3_CustomSongs.json"

local function saveCustomSongs()
    pcall(function()
        local data = {}
        for _, s in ipairs(State.customSongs) do
            table.insert(data, { name=s.name, bpm=s.bpm, category=s.category, sequence=s.sequence, emoji=s.emoji or "🎵" })
        end
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadCustomSongs()
    pcall(function()
        if isfile and isfile(SAVE_FILE) then
            local data = HttpService:JSONDecode(readfile(SAVE_FILE))
            if type(data) == "table" then
                for _, s in ipairs(data) do
                    local song = { name=s.name or "Custom", bpm=s.bpm or 120, emoji=s.emoji or "🎵", category=s.category or "Custom", sequence=s.sequence or "", speed_mult=1.0 }
                    table.insert(Songs, song)
                    table.insert(State.customSongs, song)
                end
                TOTAL_SONGS = #Songs
            end
        end
    end)
end

loadCustomSongs()
TOTAL_SONGS = #Songs

-- ══════════════════════════════════════════════════════════════
--  V4: SISTEMA DE CÓDIGO DE MÚSICA (Base64-like simples)
-- ══════════════════════════════════════════════════════════════
local function encodeSequence(seq)
    -- Converte sequência em código compartilhável (hex simples)
    local code = ""
    for i = 1, #seq do
        code = code .. string.format("%02X", string.byte(seq, i))
        if i % 32 == 0 then code = code .. "-" end
    end
    return code:sub(1, 64) -- max 64 chars do código
end

local function decodeSequence(code)
    code = code:gsub("-", "")
    local seq = ""
    for i = 1, #code - 1, 2 do
        local byte = tonumber(code:sub(i, i+1), 16)
        if byte then seq = seq .. string.char(byte) end
    end
    return seq
end

local function generateSongCode(idx)
    local song = Songs[idx]
    if not song then return "ERRO" end
    local encoded = encodeSequence(song.sequence)
    local bpmHex = string.format("%03X", song.bpm)
    return "TV4-" .. bpmHex .. "-" .. encoded:sub(1, 48)
end

-- ══════════════════════════════════════════════════════════════
--  V4: SISTEMA DE EFEITOS (Reverb / Delay / Echo)
-- ══════════════════════════════════════════════════════════════
local EffectQueue = {}

local function applyReverbEffect(keyCode, shift)
    -- Reverb: reproduz a nota levemente depois, mais fraco
    if State.reverbEnabled then
        task.delay(State.reverbLevel, function()
            pcall(function()
                local VIM2 = game:GetService("VirtualInputManager")
                if shift then VIM2:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) end
                VIM2:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VIM2:SendKeyEvent(false, keyCode, false, game)
                if shift then VIM2:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end
            end)
        end)
    end
end

local function applyDelayEffect(keyCode, shift)
    -- Delay: eco repetido
    if State.delayEnabled then
        for rep = 1, 2 do
            task.delay(State.delayTime * rep, function()
                pcall(function()
                    local VIM2 = game:GetService("VirtualInputManager")
                    if shift then VIM2:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) end
                    VIM2:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.008)
                    VIM2:SendKeyEvent(false, keyCode, false, game)
                    if shift then VIM2:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end
                end)
            end)
        end
    end
end

-- ══════════════════════════════════════════════════════════════
--  V4: SISTEMA DE PERFORMANCE (Pontuação)
-- ══════════════════════════════════════════════════════════════
local function resetPerformance()
    State.perfScore    = 0
    State.perfNotes    = 0
    State.perfAccuracy = 100
end

local function addPerfNote(perfect)
    State.perfNotes = State.perfNotes + 1
    if perfect then
        State.perfScore = State.perfScore + 100
    else
        State.perfScore = State.perfScore + 50
        State.perfAccuracy = math.max(0, math.floor((State.perfScore / (State.perfNotes * 100)) * 100))
    end
end

local function getPerfRank()
    local acc = State.perfAccuracy
    if acc >= 98 then return "S+"
    elseif acc >= 95 then return "S"
    elseif acc >= 90 then return "A"
    elseif acc >= 80 then return "B"
    elseif acc >= 70 then return "C"
    else return "D" end
end


local function parseSequence(seq)
    local tokens = {}
    local i, len = 1, #seq
    while i <= len do
        local ch = seq:sub(i, i)
        if ch == "[" then
            local j = seq:find("]", i)
            if j then
                local keys = {}
                for k = i+1, j-1 do
                    local c = seq:sub(k, k)
                    if KeyMap[c] then table.insert(keys, { key=KeyMap[c], shift=ShiftKeys[c] or false }) end
                end
                if #keys > 0 then table.insert(tokens, { type="chord", keys=keys }) end
                i = j + 1
            else i = i + 1 end
        elseif ch == "-" then table.insert(tokens, { type="dash" }); i = i + 1
        elseif ch == " " then table.insert(tokens, { type="space" }); i = i + 1
        elseif KeyMap[ch] then table.insert(tokens, { type="note", key=KeyMap[ch], shift=ShiftKeys[ch] or false }); i = i + 1
        else i = i + 1 end
    end
    return tokens
end

-- ══════════════════════════════════════════════════════════════
--  SIMULAÇÃO DE TECLAS
-- ══════════════════════════════════════════════════════════════
local VIM = game:GetService("VirtualInputManager")

local function pressKey(keyCode, shift)
    if shift then VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) end
    VIM:SendKeyEvent(true, keyCode, false, game)
    if State.humanize and Config.AntiDetectEnabled then
        task.wait(Config.HumanizeMin + math.random() * (Config.HumanizeMax - Config.HumanizeMin))
    end
    VIM:SendKeyEvent(false, keyCode, false, game)
    if shift then VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end
    -- V4: Efeitos
    applyReverbEffect(keyCode, shift)
    applyDelayEffect(keyCode, shift)
    -- V4: Contabilizar nota para performance
    addPerfNote(math.random() > 0.05) -- simula 95% precisão no auto
end

local function playChord(keys)
    for _, k in ipairs(keys) do
        if k.shift then VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game) end
        VIM:SendKeyEvent(true, k.key, false, game)
    end
    task.wait(Config.ChordDelay + (State.humanize and math.random() * 0.003 or 0))
    for _, k in ipairs(keys) do
        VIM:SendKeyEvent(false, k.key, false, game)
        if k.shift then VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end
    end
end

-- ══════════════════════════════════════════════════════════════
--  MOTOR DE PLAYBACK
-- ══════════════════════════════════════════════════════════════
local function getDelay(song)
    local bpm = song.bpm or Config.DefaultBPM
    local mult = song.speed_mult or 1.0
    local base = (60 / bpm) * 0.25 * mult
    local sm = State.speed
    if State.mode == "Nightcore" then sm = sm * Config.NightcoreSpeed
    elseif State.mode == "Slowed" then sm = sm * Config.SlowedSpeed end
    local d = base / sm
    if State.antiLag and d < Config.AntiLagThrottle then d = Config.AntiLagThrottle end
    return d
end

local function playSong(idx)
    local song = Songs[idx]
    if not song then return end
    local tokens = parseSequence(song.sequence)
    State.totalNotes = #tokens
    State.currentNote = 0
    for ti, token in ipairs(tokens) do
        if not State.isPlaying then break end
        while State.isPaused do
            task.wait(0.05)
            if not State.isPlaying then return end
        end
        local d = getDelay(song)
        if token.type == "note" then pressKey(token.key, token.shift); task.wait(d)
        elseif token.type == "chord" then playChord(token.keys); task.wait(d)
        elseif token.type == "dash" then task.wait(d * 0.8)
        elseif token.type == "space" then task.wait(d * 0.5)
        end
        State.currentNote = ti
        State.progress = ti / #tokens
    end
end

local function stopPlayback()
    State.isPlaying = false
    State.isPaused  = false
    State.progress  = 0
    State.currentNote = 0
    if State.playThread then
        pcall(function() task.cancel(State.playThread) end)
        State.playThread = nil
    end
end

local function startPlayback()
    if State.isPlaying then return end
    resetPerformance()
    State.isPlaying = true
    State.isPaused  = false
    State.playThread = task.spawn(function()
        repeat
            playSong(State.currentSong)
            if State.isPlaying then
                if State.shuffleEnabled then State.currentSong = math.random(1, TOTAL_SONGS)
                elseif not State.loopEnabled then State.currentSong = (State.currentSong % TOTAL_SONGS) + 1
                end
            end
        until not State.isPlaying
        State.isPlaying = false
    end)
end

local function pauseResume()
    if not State.isPlaying then startPlayback()
    else State.isPaused = not State.isPaused end
end

local function nextSong()
    stopPlayback()
    State.currentSong = State.shuffleEnabled and math.random(1, TOTAL_SONGS) or (State.currentSong % TOTAL_SONGS) + 1
end

local function prevSong()
    stopPlayback()
    State.currentSong = ((State.currentSong - 2) % TOTAL_SONGS) + 1
end

-- ══════════════════════════════════════════════════════════════
--  CONSTRUIR LISTA DE MÚSICAS (para Rayfield Dropdown)
-- ══════════════════════════════════════════════════════════════
local function buildSongNames(filter)
    local names = {}
    local f = filter and filter:lower() or ""
    for i, s in ipairs(Songs) do
        if f == "" or s.name:lower():find(f, 1, true) then
            table.insert(names, i .. ". " .. (s.emoji or "♪") .. " " .. s.name)
        end
    end
    return names
end

local function songNameToIndex(name)
    local numStr = name:match("^(%d+)%.")
    if numStr then return tonumber(numStr) end
    return 1
end

-- ══════════════════════════════════════════════════════════════
--  CRIAR JANELA RAYFIELD
-- ══════════════════════════════════════════════════════════════
local Window = Rayfield:CreateWindow({
    Name            = "Talentless V4 — Mega Edition",
    Icon            = 0,
    LoadingTitle    = "Talentless V4 Mega",
    LoadingSubtitle = "Carregando " .. TOTAL_SONGS .. " musicas...",
    Theme           = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings   = false,
    ConfigurationSaving = {
        Enabled  = false,
        FolderName = nil,
        FileName   = nil,
    },
    Discord = {
        Enabled      = false,
        Invite       = "",
        RememberJoins = false,
    },
    KeySystem = false,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 1: PLAYER
-- ══════════════════════════════════════════════════════════════
local TabPlayer = Window:CreateTab("♪ Player", nil)

-- Status Now Playing
local NowPlayingLabel = TabPlayer:CreateSection("Now Playing")

local StatusLabel = TabPlayer:CreateLabel(
    "♪  " .. Songs[State.currentSong].emoji .. "  " .. Songs[State.currentSong].name
)

local InfoLabel = TabPlayer:CreateLabel(
    "Status: Parado   |   BPM: " .. Songs[State.currentSong].bpm .. "   |   #" .. State.currentSong .. "/" .. TOTAL_SONGS
)

local function refreshPlayerLabels()
    local song = Songs[State.currentSong]
    if not song then return end
    local st = State.isPlaying and (State.isPaused and "Pausado" or "Tocando") or "Parado"
    StatusLabel:Set("♪  " .. (song.emoji or "♪") .. "  " .. song.name)
    InfoLabel:Set("Status: " .. st .. "   |   BPM: " .. song.bpm .. "   |   #" .. State.currentSong .. "/" .. TOTAL_SONGS)
end

-- Controles
TabPlayer:CreateSection("Controles")

TabPlayer:CreateButton({
    Name     = "▶  PLAY",
    Callback = function()
        if State.isPlaying and State.isPaused then State.isPaused = false
        elseif not State.isPlaying then startPlayback() end
        Rayfield:Notify({ Title="Tocando", Content=Songs[State.currentSong].name, Duration=2 })
    end,
})

TabPlayer:CreateButton({
    Name     = "⏸  PAUSE / RESUME",
    Callback = function()
        pauseResume()
        Rayfield:Notify({ Title=State.isPaused and "Pausado" or "Tocando", Content=Songs[State.currentSong].name, Duration=2 })
    end,
})

TabPlayer:CreateButton({
    Name     = "⏹  STOP",
    Callback = function()
        stopPlayback()
        refreshPlayerLabels()
        Rayfield:Notify({ Title="Parado", Content="Playback interrompido.", Duration=2 })
    end,
})

TabPlayer:CreateButton({
    Name     = "⏭  NEXT",
    Callback = function()
        nextSong()
        refreshPlayerLabels()
        Rayfield:Notify({ Title="Proxima", Content=Songs[State.currentSong].name, Duration=2 })
    end,
})

TabPlayer:CreateButton({
    Name     = "⏮  PREV",
    Callback = function()
        prevSong()
        refreshPlayerLabels()
        Rayfield:Notify({ Title="Anterior", Content=Songs[State.currentSong].name, Duration=2 })
    end,
})

-- Loop e Shuffle
TabPlayer:CreateSection("Modos")

TabPlayer:CreateToggle({
    Name    = "🔁  Loop",
    CurrentValue = false,
    Flag    = "Loop",
    Callback = function(v)
        State.loopEnabled = v
        if v then State.shuffleEnabled = false end
    end,
})

TabPlayer:CreateToggle({
    Name    = "🔀  Shuffle",
    CurrentValue = false,
    Flag    = "Shuffle",
    Callback = function(v)
        State.shuffleEnabled = v
        if v then State.loopEnabled = false end
    end,
})

TabPlayer:CreateDropdown({
    Name    = "Modo de Velocidade",
    Options = { "Normal", "Nightcore (+35%)", "Slowed+Reverb (-25%)" },
    CurrentOption = { "Normal" },
    MultipleOptions = false,
    Flag    = "VelocidadeModo",
    Callback = function(opt)
        local v = type(opt) == "table" and opt[1] or opt
        if v:find("Nightcore") then State.mode = "Nightcore"
        elseif v:find("Slowed") then State.mode = "Slowed"
        else State.mode = "Normal" end
        Rayfield:Notify({ Title="Modo", Content="Modo: " .. State.mode, Duration=2 })
    end,
})

-- Velocidade (Slider)
TabPlayer:CreateSection("Velocidade")

TabPlayer:CreateSlider({
    Name         = "Velocidade de Reproducao",
    Range        = { Config.MinSpeed * 100, Config.MaxSpeed * 100 },
    Increment    = math.floor(Config.SpeedStep * 100),
    Suffix       = "%",
    CurrentValue = 100,
    Flag         = "SpeedSlider",
    Callback     = function(v)
        State.speed = v / 100
    end,
})

TabPlayer:CreateButton({
    Name     = "↺  Reset Velocidade (1.0x)",
    Callback = function()
        State.speed = 1.0
        Rayfield:Notify({ Title="Reset", Content="Velocidade resetada para 1.0x", Duration=2 })
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 2: MÚSICAS
-- ══════════════════════════════════════════════════════════════
local TabSongs = Window:CreateTab("♫ Musicas", nil)

TabSongs:CreateSection("Selecionar Musica")

-- Todas as musicas como dropdown agrupadas por categoria
local allSongNames = {}
for i, s in ipairs(Songs) do
    table.insert(allSongNames, i .. ". " .. (s.emoji or "♪") .. " " .. s.name)
end

TabSongs:CreateDropdown({
    Name            = "Escolher Musica",
    Options         = allSongNames,
    CurrentOption   = { allSongNames[1] },
    MultipleOptions = false,
    Flag            = "SongSelect",
    Callback        = function(opt)
        local v = type(opt) == "table" and opt[1] or opt
        local idx = songNameToIndex(v)
        if idx and Songs[idx] then
            stopPlayback()
            State.currentSong = idx
            refreshPlayerLabels()
            Rayfield:Notify({ Title="Selecionada", Content=Songs[idx].name, Duration=2 })
        end
    end,
})

-- Filtro por categoria
TabSongs:CreateSection("Filtrar por Categoria")

local Categories = { "Pop", "Anime", "Games", "Rock", "Classica", "EDM", "Meme", "Funk", "Hip-Hop", "Indie", "K-Pop", "Sertanejo" }

for _, cat in ipairs(Categories) do
    local catSongs = {}
    for i, s in ipairs(Songs) do
        if s.category == cat then
            table.insert(catSongs, i .. ". " .. (s.emoji or "♪") .. " " .. s.name)
        end
    end
    if #catSongs > 0 then
        TabSongs:CreateDropdown({
            Name            = cat .. " (" .. #catSongs .. ")",
            Options         = catSongs,
            CurrentOption   = { catSongs[1] },
            MultipleOptions = false,
            Flag            = "Cat_" .. cat,
            Callback        = function(opt)
                local v = type(opt) == "table" and opt[1] or opt
                local idx = songNameToIndex(v)
                if idx and Songs[idx] then
                    stopPlayback()
                    State.currentSong = idx
                    refreshPlayerLabels()
                    Rayfield:Notify({ Title="Selecionada", Content=Songs[idx].name, Duration=2 })
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════════════════════════
--  ABA 3: CUSTOM SONGS
-- ══════════════════════════════════════════════════════════════
local TabCustom = Window:CreateTab("+ Custom", nil)

TabCustom:CreateSection("Criar Musica Custom")

local customName = ""
local customBPM  = "120"
local customCat  = "Custom"
local customSeq  = ""

TabCustom:CreateInput({
    Name         = "Nome da Musica",
    PlaceholderText = "Ex: Minha Musica Incrivel",
    NumbersOnly  = false,
    RemoveTextAfterFocusLost = false,
    Flag         = "CustomName",
    Callback     = function(v) customName = v end,
})

TabCustom:CreateInput({
    Name         = "BPM",
    PlaceholderText = "Ex: 120",
    NumbersOnly  = true,
    RemoveTextAfterFocusLost = false,
    Flag         = "CustomBPM",
    Callback     = function(v) customBPM = v end,
})

TabCustom:CreateInput({
    Name         = "Categoria / Estilo",
    PlaceholderText = "Ex: Pop, Anime, Funk...",
    NumbersOnly  = false,
    RemoveTextAfterFocusLost = false,
    Flag         = "CustomCat",
    Callback     = function(v) customCat = v ~= "" and v or "Custom" end,
})

TabCustom:CreateInput({
    Name         = "Notas / Sequencia de Teclas",
    PlaceholderText = "Ex: q w e r t y [qe] [wr]...",
    NumbersOnly  = false,
    RemoveTextAfterFocusLost = false,
    Flag         = "CustomSeq",
    Callback     = function(v) customSeq = v end,
})

TabCustom:CreateButton({
    Name     = "✓ SALVAR MUSICA CUSTOM",
    Callback = function()
        if customName == "" or customSeq == "" then
            Rayfield:Notify({ Title="Erro", Content="Preencha o nome e as notas!", Duration=3 })
            return
        end
        local bpm = tonumber(customBPM) or 120
        local song = { name=customName .. " (Custom)", bpm=bpm, speed_mult=1.0, emoji="🎵", category=customCat, sequence=customSeq }
        table.insert(Songs, song)
        table.insert(State.customSongs, song)
        TOTAL_SONGS = #Songs
        saveCustomSongs()
        Rayfield:Notify({ Title="Salvo!", Content=customName .. " adicionada! (#" .. TOTAL_SONGS .. ")", Duration=4 })
    end,
})

TabCustom:CreateSection("Tocar Custom Rapido")

TabCustom:CreateButton({
    Name     = "▶ Tocar Ultima Custom Criada",
    Callback = function()
        if #State.customSongs == 0 then
            Rayfield:Notify({ Title="Erro", Content="Nenhuma custom criada ainda!", Duration=3 })
            return
        end
        stopPlayback()
        State.currentSong = TOTAL_SONGS
        refreshPlayerLabels()
        startPlayback()
        Rayfield:Notify({ Title="Tocando Custom", Content=Songs[TOTAL_SONGS].name, Duration=3 })
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 4: I.A. / ANTI-DETECTION
-- ══════════════════════════════════════════════════════════════
local TabAI = Window:CreateTab("◆ I.A.", nil)

TabAI:CreateSection("Modo Inteligencia Artificial")

TabAI:CreateToggle({
    Name         = "Humanize (Anti-Detection)",
    CurrentValue = true,
    Flag         = "Humanize",
    Callback     = function(v)
        State.humanize        = v
        Config.AntiDetectEnabled = v
        Rayfield:Notify({ Title="Humanize", Content=v and "Ativado — Toques humanizados" or "Desativado", Duration=2 })
    end,
})

TabAI:CreateToggle({
    Name         = "Anti-Lag (Throttle minimo)",
    CurrentValue = true,
    Flag         = "AntiLag",
    Callback     = function(v)
        State.antiLag = v
        Rayfield:Notify({ Title="Anti-Lag", Content=v and "Ativado" or "Desativado", Duration=2 })
    end,
})

TabAI:CreateSection("Configuracoes Avancadas")

TabAI:CreateSlider({
    Name         = "Delay de Humanize Min (ms)",
    Range        = { 1, 20 },
    Increment    = 1,
    Suffix       = "ms",
    CurrentValue = math.floor(Config.HumanizeMin * 1000),
    Flag         = "HumanMin",
    Callback     = function(v) Config.HumanizeMin = v / 1000 end,
})

TabAI:CreateSlider({
    Name         = "Delay de Humanize Max (ms)",
    Range        = { 5, 50 },
    Increment    = 1,
    Suffix       = "ms",
    CurrentValue = math.floor(Config.HumanizeMax * 1000),
    Flag         = "HumanMax",
    Callback     = function(v) Config.HumanizeMax = v / 1000 end,
})

TabAI:CreateSlider({
    Name         = "Delay de Acorde (ms)",
    Range        = { 5, 80 },
    Increment    = 5,
    Suffix       = "ms",
    CurrentValue = math.floor(Config.ChordDelay * 1000),
    Flag         = "ChordDelay",
    Callback     = function(v) Config.ChordDelay = v / 1000 end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 5: EFEITOS DE SOM (V4 NOVO)
-- ══════════════════════════════════════════════════════════════
local TabEfeitos = Window:CreateTab("🎧 Efeitos", nil)

TabEfeitos:CreateSection("Reverb (Eco de sala)")

TabEfeitos:CreateToggle({
    Name         = "🌊  Reverb",
    CurrentValue = false,
    Flag         = "ReverbToggle",
    Callback     = function(v)
        State.reverbEnabled = v
        Rayfield:Notify({ Title="Reverb", Content=v and "Ativado — notas com eco!" or "Desativado", Duration=2 })
    end,
})

TabEfeitos:CreateSlider({
    Name         = "Intensidade do Reverb",
    Range        = { 5, 60 },
    Increment    = 5,
    Suffix       = "0ms",
    CurrentValue = 30,
    Flag         = "ReverbLevel",
    Callback     = function(v)
        State.reverbLevel = v / 100
    end,
})

TabEfeitos:CreateSection("Delay (Eco repetido)")

TabEfeitos:CreateToggle({
    Name         = "🔁  Delay / Echo",
    CurrentValue = false,
    Flag         = "DelayToggle",
    Callback     = function(v)
        State.delayEnabled = v
        Rayfield:Notify({ Title="Delay", Content=v and "Ativado — duplo eco!" or "Desativado", Duration=2 })
    end,
})

TabEfeitos:CreateSlider({
    Name         = "Tempo do Delay",
    Range        = { 5, 50 },
    Increment    = 5,
    Suffix       = "0ms",
    CurrentValue = 15,
    Flag         = "DelayTime",
    Callback     = function(v)
        State.delayTime = v / 100
    end,
})

TabEfeitos:CreateSection("Preset de Efeitos")

TabEfeitos:CreateButton({
    Name     = "🎹  Preset: Piano Sala de Concerto",
    Callback = function()
        State.reverbEnabled = true
        State.reverbLevel   = 0.45
        State.delayEnabled  = false
        Rayfield:Notify({ Title="Preset Aplicado", Content="Piano Sala de Concerto (Reverb forte)", Duration=3 })
    end,
})

TabEfeitos:CreateButton({
    Name     = "🌌  Preset: Lofi / Slowed+Reverb",
    Callback = function()
        State.reverbEnabled = true
        State.reverbLevel   = 0.3
        State.delayEnabled  = true
        State.delayTime     = 0.2
        State.mode          = "Slowed"
        Rayfield:Notify({ Title="Preset Aplicado", Content="Lofi Slowed+Reverb ativado!", Duration=3 })
    end,
})

TabEfeitos:CreateButton({
    Name     = "⚡  Preset: Nightcore + Echo",
    Callback = function()
        State.reverbEnabled = false
        State.delayEnabled  = true
        State.delayTime     = 0.10
        State.mode          = "Nightcore"
        Rayfield:Notify({ Title="Preset Aplicado", Content="Nightcore + Echo ativado!", Duration=3 })
    end,
})

TabEfeitos:CreateButton({
    Name     = "✖  Limpar Todos Efeitos",
    Callback = function()
        State.reverbEnabled = false
        State.delayEnabled  = false
        State.mode          = "Normal"
        Rayfield:Notify({ Title="Efeitos", Content="Todos os efeitos removidos.", Duration=2 })
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 6: DUETO (V4 NOVO)
-- ══════════════════════════════════════════════════════════════
local TabDueto = Window:CreateTab("👥 Dueto", nil)

TabDueto:CreateSection("Sistema de Dueto — 2 Musicas Juntas")

TabDueto:CreateLabel("🎹  No dueto, duas musicas tocam ao mesmo tempo.")
TabDueto:CreateLabel("    Player 1 = musica selecionada no Player.")
TabDueto:CreateLabel("    Player 2 = musica selecionada abaixo.")

local duetSongNames = {}
for i, s in ipairs(Songs) do
    table.insert(duetSongNames, i .. ". " .. (s.emoji or "♪") .. " " .. s.name)
end

TabDueto:CreateDropdown({
    Name            = "Musica do Player 2 (Dueto)",
    Options         = duetSongNames,
    CurrentOption   = { duetSongNames[2] },
    MultipleOptions = false,
    Flag            = "DuetSong2",
    Callback        = function(opt)
        local v = type(opt) == "table" and opt[1] or opt
        local numStr = v:match("^(%d+)%.")
        if numStr then State.duetSong2 = tonumber(numStr) end
    end,
})

TabDueto:CreateSlider({
    Name         = "Delay do Player 2 (ms)",
    Range        = { 0, 200 },
    Increment    = 10,
    Suffix       = "ms",
    CurrentValue = 0,
    Flag         = "DuetDelay",
    Callback     = function(v)
        -- Armazena delay do segundo player
        Config.DuetOffset = v / 1000
    end,
})

TabDueto:CreateButton({
    Name     = "🎭  INICIAR DUETO",
    Callback = function()
        if State.duetEnabled then
            Rayfield:Notify({ Title="Dueto", Content="Dueto ja esta ativo! Pare primeiro.", Duration=3 })
            return
        end
        State.duetEnabled = true
        -- Para qualquer playback anterior
        stopPlayback()
        resetPerformance()
        State.isPlaying = true
        State.isPaused  = false

        local offset = Config.DuetOffset or 0
        local song1idx = State.currentSong
        local song2idx = State.duetSong2

        -- Thread Player 1
        State.playThread = task.spawn(function()
            playSong(song1idx)
            State.isPlaying  = false
            State.duetEnabled = false
        end)

        -- Thread Player 2 com delay
        State.duetThread = task.spawn(function()
            if offset > 0 then task.wait(offset) end
            playSong(song2idx)
        end)

        Rayfield:Notify({
            Title   = "🎭 Dueto Iniciado!",
            Content = Songs[song1idx].name .. " + " .. Songs[song2idx].name,
            Duration = 4,
        })
    end,
})

TabDueto:CreateButton({
    Name     = "⏹  PARAR DUETO",
    Callback = function()
        State.duetEnabled = false
        stopPlayback()
        if State.duetThread then
            pcall(function() task.cancel(State.duetThread) end)
            State.duetThread = nil
        end
        Rayfield:Notify({ Title="Dueto", Content="Dueto encerrado.", Duration=2 })
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 7: CÓDIGO DE MÚSICA (V4 NOVO)
-- ══════════════════════════════════════════════════════════════
local TabCodigo = Window:CreateTab("🔗 Codigo", nil)

TabCodigo:CreateSection("Compartilhar Musica por Codigo")
TabCodigo:CreateLabel("Gere um codigo da musica atual e compartilhe!")
TabCodigo:CreateLabel("O amigo cola o codigo e toca igual.")

local lastGeneratedCode = ""

TabCodigo:CreateButton({
    Name     = "📋  Gerar Codigo da Musica Atual",
    Callback = function()
        local song = Songs[State.currentSong]
        local code = generateSongCode(State.currentSong)
        lastGeneratedCode = code
        Rayfield:Notify({
            Title   = "Codigo Gerado!",
            Content = code,
            Duration = 8,
        })
        -- Também imprime no console para facilitar copiar
        print("[TV4] CODIGO DA MUSICA: " .. song.name)
        print("[TV4] " .. code)
        warn("COPIE O CODIGO ACIMA NO CONSOLE!")
    end,
})

TabCodigo:CreateSection("Importar Codigo")
TabCodigo:CreateLabel("Cole o codigo abaixo para importar uma musica.")

local importCodeStr = ""
local importNameStr = "Musica Importada"

TabCodigo:CreateInput({
    Name            = "Codigo (TV4-XXX-...)",
    PlaceholderText = "Cole o codigo aqui: TV4-078-...",
    NumbersOnly     = false,
    RemoveTextAfterFocusLost = false,
    Flag            = "ImportCode",
    Callback        = function(v) importCodeStr = v end,
})

TabCodigo:CreateInput({
    Name            = "Nome para a musica importada",
    PlaceholderText = "Ex: Musica do Amigo",
    NumbersOnly     = false,
    RemoveTextAfterFocusLost = false,
    Flag            = "ImportName",
    Callback        = function(v) importNameStr = v ~= "" and v or "Musica Importada" end,
})

TabCodigo:CreateButton({
    Name     = "✓  IMPORTAR E ADICIONAR",
    Callback = function()
        if importCodeStr == "" or not importCodeStr:find("^TV4%-") then
            Rayfield:Notify({ Title="Erro", Content="Codigo invalido! Use formato TV4-XXX-...", Duration=3 })
            return
        end
        -- Extrai BPM e sequencia do codigo
        local parts = {}
        for p in importCodeStr:gmatch("[^%-]+") do table.insert(parts, p) end
        if #parts < 3 then
            Rayfield:Notify({ Title="Erro", Content="Codigo corrompido.", Duration=3 })
            return
        end
        local bpmVal = tonumber(parts[2], 16) or 120
        local seqEncoded = parts[3] or ""
        local seq = decodeSequence(seqEncoded)
        if seq == "" then
            Rayfield:Notify({ Title="Erro", Content="Nao foi possivel decodificar.", Duration=3 })
            return
        end
        local newSong = {
            name      = importNameStr .. " (Codigo)",
            bpm       = bpmVal,
            emoji     = "🔗",
            category  = "Custom",
            sequence  = seq,
            speed_mult = 1.0,
        }
        table.insert(Songs, newSong)
        table.insert(State.customSongs, newSong)
        TOTAL_SONGS = #Songs
        saveCustomSongs()
        Rayfield:Notify({
            Title   = "Importado!",
            Content = importNameStr .. " adicionada como #" .. TOTAL_SONGS,
            Duration = 4,
        })
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 8: PERFORMANCE (V4 NOVO)
-- ══════════════════════════════════════════════════════════════
local TabPerf = Window:CreateTab("📊 Performance", nil)

TabPerf:CreateSection("Resultado da Ultima Execucao")

local PerfScoreLabel    = TabPerf:CreateLabel("Pontuacao:  0")
local PerfNotesLabel    = TabPerf:CreateLabel("Notas tocadas:  0")
local PerfAccLabel      = TabPerf:CreateLabel("Precisao:  100%")
local PerfRankLabel     = TabPerf:CreateLabel("Rank:  --")
local PerfSongLabel     = TabPerf:CreateLabel("Musica:  --")

TabPerf:CreateSection("Controles de Performance")

TabPerf:CreateButton({
    Name     = "🔄  Atualizar Painel",
    Callback = function()
        local rank = getPerfRank()
        PerfScoreLabel:Set("Pontuacao:  " .. State.perfScore)
        PerfNotesLabel:Set("Notas tocadas:  " .. State.perfNotes)
        PerfAccLabel:Set("Precisao:  " .. State.perfAccuracy .. "%")
        PerfRankLabel:Set("Rank:  " .. rank)
        PerfSongLabel:Set("Musica:  " .. (Songs[State.currentSong] and Songs[State.currentSong].name or "--"))
        Rayfield:Notify({
            Title   = "Performance — Rank " .. rank,
            Content = "Pontos: " .. State.perfScore .. " | Precisao: " .. State.perfAccuracy .. "%",
            Duration = 4,
        })
    end,
})

TabPerf:CreateButton({
    Name     = "🗑  Zerar Performance",
    Callback = function()
        resetPerformance()
        PerfScoreLabel:Set("Pontuacao:  0")
        PerfNotesLabel:Set("Notas tocadas:  0")
        PerfAccLabel:Set("Precisao:  100%")
        PerfRankLabel:Set("Rank:  --")
        Rayfield:Notify({ Title="Performance", Content="Zerada com sucesso!", Duration=2 })
    end,
})

TabPerf:CreateSection("Ranking de Ranks")
TabPerf:CreateLabel("S+  = 98%+ precisao — PERFEITO")
TabPerf:CreateLabel("S   = 95%+ precisao — EXCELENTE")
TabPerf:CreateLabel("A   = 90%+ precisao — OTIMO")
TabPerf:CreateLabel("B   = 80%+ precisao — BOM")
TabPerf:CreateLabel("C   = 70%+ precisao — REGULAR")
TabPerf:CreateLabel("D   = abaixo de 70% — TREINE MAIS")

TabPerf:CreateSection("Loop de Trecho")
TabPerf:CreateLabel("Repete uma parte da musica automaticamente.")
TabPerf:CreateLabel("Util para praticar trechos especificos.")

TabPerf:CreateToggle({
    Name         = "🔁  Ativar Loop de Trecho",
    CurrentValue = false,
    Flag         = "LoopSection",
    Callback     = function(v)
        State.loopSectionEnabled = v
        Rayfield:Notify({ Title="Loop de Trecho", Content=v and "Ativado!" or "Desativado", Duration=2 })
    end,
})

TabPerf:CreateSlider({
    Name         = "Inicio do Loop (%)",
    Range        = { 0, 90 },
    Increment    = 5,
    Suffix       = "%",
    CurrentValue = 0,
    Flag         = "LoopStart",
    Callback     = function(v)
        State.loopStart = v
    end,
})

TabPerf:CreateSlider({
    Name         = "Fim do Loop (%)",
    Range        = { 10, 100 },
    Increment    = 5,
    Suffix       = "%",
    CurrentValue = 100,
    Flag         = "LoopEnd",
    Callback     = function(v)
        State.loopEnd = v
    end,
})

-- ══════════════════════════════════════════════════════════════
--  ABA 9: CONFIGURAÇÕES
-- ══════════════════════════════════════════════════════════════
local TabConfig = Window:CreateTab("⚙ Config", nil)

TabConfig:CreateSection("Configuracoes de Reproducao")

TabConfig:CreateSlider({
    Name         = "BPM Override (0 = usar BPM da musica)",
    Range        = { 0, 300 },
    Increment    = 5,
    Suffix       = " bpm",
    CurrentValue = 0,
    Flag         = "BPMOverride",
    Callback     = function(v)
        Config.DefaultBPM = v == 0 and 120 or v
    end,
})

TabConfig:CreateSection("Anti-AFK")

TabConfig:CreateToggle({
    Name         = "Anti-AFK / Anti-Kick",
    CurrentValue = true,
    Flag         = "AntiAFK",
    Callback     = function(v)
        Rayfield:Notify({ Title="Anti-AFK", Content=v and "Ativado" or "Desativado", Duration=2 })
    end,
})

TabConfig:CreateSection("Atalhos de Teclado")

TabConfig:CreateLabel("F1  →  Mostrar/Ocultar GUI Rayfield")
TabConfig:CreateLabel("F2  →  Play / Pause")
TabConfig:CreateLabel("F3  →  Stop")
TabConfig:CreateLabel("F4  →  Proxima Musica")
TabConfig:CreateLabel("F5  →  Musica Anterior")
TabConfig:CreateLabel("F6  →  Toggle Loop")
TabConfig:CreateLabel("F7  →  Toggle Shuffle")
TabConfig:CreateLabel("F8  →  Toggle Humanize/I.A.")
TabConfig:CreateLabel("F9  →  Toggle Loop de Trecho")

-- ══════════════════════════════════════════════════════════════
--  ABA 10: CRÉDITOS
-- ══════════════════════════════════════════════════════════════
local TabDev = Window:CreateTab("★ Creditos", nil)

TabDev:CreateSection("Talentless V4 — MEGA EDITION")
TabDev:CreateLabel("Versao: " .. VERSION.full .. " (Rayfield Edition)")
TabDev:CreateLabel("Codename: " .. VERSION.codename)
TabDev:CreateLabel("Musicas: " .. TOTAL_SONGS)

TabDev:CreateSection("Desenvolvedores")

for _, credit in ipairs(CREDITS) do
    TabDev:CreateLabel(credit.emoji .. "  " .. credit.name .. "  —  " .. credit.role)
end

TabDev:CreateSection("Novidades V4 Mega Edition")
TabDev:CreateLabel("✦  130+ musicas — Pop, Anime, Sertanejo, K-Pop e mais!")
TabDev:CreateLabel("✦  Sistema de Dueto — 2 musicas ao mesmo tempo")
TabDev:CreateLabel("✦  Codigo de Musica — compartilhe com amigos")
TabDev:CreateLabel("✦  Efeitos de Som — Reverb, Delay, Presets")
TabDev:CreateLabel("✦  Sistema de Performance — Rank S+ a D")
TabDev:CreateLabel("✦  Loop de Trecho — treino de partes especificas")
TabDev:CreateLabel("✦  Sertanejo, K-Pop expandido, Indie e mais")
TabDev:CreateLabel("✦  Atalho F9 = Loop de Trecho")
TabDev:CreateLabel("✦  Interface 10 abas completas")
TabDev:CreateLabel("✦  Anti-Lag, Humanize e Anti-AFK mantidos")

TabDev:CreateSection("Agradecimentos")
TabDev:CreateLabel("Obrigado a toda a comunidade Talentless!")
TabDev:CreateLabel("Continuem tocando e compartilhando musicas!")
TabDev:CreateLabel("V4 — Nexus Edition. Feito com muito carinho.")

-- ══════════════════════════════════════════════════════════════
--  KEYBINDS (F1–F9)
-- ══════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F2 then
        pauseResume()
        refreshPlayerLabels()
        Rayfield:Notify({ Title=State.isPaused and "Pausado" or "Tocando", Content=Songs[State.currentSong].name, Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F3 then
        stopPlayback(); refreshPlayerLabels()
        Rayfield:Notify({ Title="Parado", Content="Playback interrompido", Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F4 then
        nextSong(); refreshPlayerLabels()
        Rayfield:Notify({ Title="Next", Content=Songs[State.currentSong].name, Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F5 then
        prevSong(); refreshPlayerLabels()
        Rayfield:Notify({ Title="Prev", Content=Songs[State.currentSong].name, Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F6 then
        State.loopEnabled = not State.loopEnabled
        if State.loopEnabled then State.shuffleEnabled = false end
        Rayfield:Notify({ Title="Loop", Content=State.loopEnabled and "Ativado" or "Desativado", Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F7 then
        State.shuffleEnabled = not State.shuffleEnabled
        if State.shuffleEnabled then State.loopEnabled = false end
        Rayfield:Notify({ Title="Shuffle", Content=State.shuffleEnabled and "Ativado" or "Desativado", Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F8 then
        State.humanize = not State.humanize
        Config.AntiDetectEnabled = State.humanize
        Rayfield:Notify({ Title="Humanize/I.A.", Content=State.humanize and "Ativado" or "Desativado", Duration=2 })
    elseif input.KeyCode == Enum.KeyCode.F9 then
        -- V4: F9 = Toggle Loop de Trecho
        State.loopSectionEnabled = not State.loopSectionEnabled
        Rayfield:Notify({ Title="Loop de Trecho", Content=State.loopSectionEnabled and "Ativado (F9)" or "Desativado (F9)", Duration=2 })
    end
end)

-- ══════════════════════════════════════════════════════════════
--  UPDATE LOOP — Atualiza labels + Performance a cada 0.5s
-- ══════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(0.5)
        refreshPlayerLabels()
        -- Atualiza painel de performance automaticamente se estiver tocando
        if State.isPlaying and State.perfNotes > 0 then
            pcall(function()
                local rank = getPerfRank()
                PerfScoreLabel:Set("Pontuacao:  " .. State.perfScore)
                PerfNotesLabel:Set("Notas tocadas:  " .. State.perfNotes)
                PerfAccLabel:Set("Precisao:  " .. State.perfAccuracy .. "%")
                PerfRankLabel:Set("Rank:  " .. rank)
                PerfSongLabel:Set("Musica:  " .. (Songs[State.currentSong] and Songs[State.currentSong].name or "--"))
            end)
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
--  ANTI-AFK
-- ══════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(120)
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════
--  INICIALIZAR V4
-- ══════════════════════════════════════════════════════════════
Rayfield:Notify({
    Title    = "Talentless V4 Carregado!",
    Content  = TOTAL_SONGS .. " musicas! Dueto, Efeitos, Codigo e mais. F2-F9.",
    Duration = 7,
    Image    = 4483362458,
})


-- ══════════════════════════════════════════════════════════════
--  PAINEL ADM — TALENTLESS V4 (VERSAO CORRIGIDA + TOUCH + VIP)
-- ══════════════════════════════════════════════════════════════

-- ── CONFIG ADM ──
local ADM_CODE = "TV4-ADM-NEXUS"
local ADM_MODERADORES = {
    { nome = "gb dskp", cargo = "Moderador", emoji = "🛡️" },
    { nome = "Fofas",   cargo = "Dono",      emoji = "👑" },
}
local ADM_DEVS = {
    { nome = "Beicon_129 (333)", cargo = "Lead Developer", emoji = "💻" },
    { nome = "Dkgune (Rdd)",     cargo = "Co-Developer",   emoji = "⚡" },
    { nome = "Davi Scripts",     cargo = "Tester",         emoji = "🛠️" },
    { nome = "C00Ikiddban",      cargo = "Community",      emoji = "🌟" },
}

local admPanelOpen = false
local admGuiAberto = nil
local admIsMobile = false
pcall(function()
    admIsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end)

-- ── MÚSICAS VIP EXCLUSIVAS (ADM ONLY — não existem na free) ──
local VIP_SONGS = {
    { name="Unravel — Tokyo Ghoul (Full OP)",     bpm=152, emoji="🎭", category="VIP-Anime",    sequence="J l-J-j h- l-J-j-h- h g--D D-g d---- d [(d]-d d ( z z- w--w-- J [jq]-j j q J J- 9--9-- J [(^l]-J-[(^j] h- l [9w] J-j [9w] h- h [8gq]--D [8Dq]-g d [^9]--[^9]-- d [(^d]-d d [(^] z z- [9w]--[9w]-- J [8jq]-j j [8q] J J- [5w]---- d-s-P d-s- P [5w][5w] [5w] [5w][5w] [5w][5w] [5w][5w]- [dw]J d[hq] d ( d [9s]d- [dw]J d[hq] d ( J 9j- [dw]J d[hq] d ( d [9s]d- [dw]J d[hq] d ( J Qj- E-w-t E-w- [pt] [Py]-P-[Pt]--P d [dq]-s-s-- P [qs]-P-[pt]-i- y t--E-- i [Ei] y[ey]-[ey] [Et] y[ey]- [ei] [Ei] y[ey]-[ey] [Et] y[ey]- [ei] [Ei] y[ey]-[Ey] [et]-[Ey]- [Ey]--y [Ey]--y" },
    { name="Megalovania — Undertale (Genocide)",  bpm=120, emoji="☠️", category="VIP-Games",    sequence="t t d p O o i y i o r r d p O o i y i o E E d p O o i y i o y y d p O o i y i o t t d p O o i y i o r r d p O o i y i o E E d p O o i y i o 9 9 d p O o i y i o 8 8 d p O o i y i o 7 7 d p O o i y i o ^ ^ d p O o i y i o 9 9 d p O o i y i o 8 8 d p O o i y i o 7 7 d p O o i y i o ^ ^ d p O o i y i o [i9] i i i i o i [i8] i i o O o i y i o [i7] i i o O p s p [d^] d d p d s 8 h [p9] p p p p o o [p8] p p p p o d p o [d7] p o y s o i u [y^] u i p s 8" },
    { name="Interstellar — Hans Zimmer (Full)",    bpm=55,  emoji="🚀", category="VIP-Classica", sequence="[4qe] [4qe] [4qe] [4qe] [4qr] [4qr] [4qt] [4qt] [6qe] [6qe] [6qe] [6qe] [6qr] [6qr] [6qt] [6qt] [5qw] [5qw] [5qw] [5qw] [5qe] [5qe] [5qr] [5qr] [3qw] [3qw] [3qw] [3qw] [3qe] [3qe] [3qr] [3qr] [4qe] [4qe] [4qe] [4qe] [4qr] [4qr] [4qt] [4qt] [6qe] [6qe] [6qe] [6qe] [6qr] [6qr] [6qt] [6qt] [5qw] [5qw] [5qw] [5qw] [5qe] [5qe] [5qr] [5qr] [3qw] [3qw] [3qw] [3qw] [3qe] [3qe] [3qr] [3qr]" },
    { name="Canon in D — Pachelbel (Orchestral)",   bpm=65,  emoji="🎻", category="VIP-Classica", sequence="[4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [6qi] [qi] [qi] [qi] [6qo] [qo] [qo] [qo] [5qo] [qo] [qo] [qo] [5qi] [qi] [qi] [qi] [3qu] [qu] [qu] [qu] [3qy] [qy] [qy] [qy] [4i] q i p i q [4p] o i u i o [6i] q i p i q [6i] q i o u y [5o] w o i o w [5o] w o i u y [3u] w u y u w [3u] w u y t e [4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [6qi] [qi] [qi] [qi] [6qo] [qo] [qo] [qo] [5qo] [qo] [qo] [qo] [5qi] [qi] [qi] [qi] [3qu] [qu] [qu] [qu] [3qy] [qy] [qy] [qy]" },
    { name="Fur Elise — Beethoven (Concerto)",      bpm=90,  emoji="🎼", category="VIP-Classica", sequence="EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtp [0ywq] EwEwEiEwE ypEtu qEtp [0ywq] [3wyo] [5wyi] [6oep] [3wyp] [6oep] [8etp] [0etps] [8etpd] [3wyd] [5wys] [6oep] [3wyp] [4qei] [6etu] [0ety] EwEwEiEwE ypEtu qEtu [1yrq] EwEwEiEwE ypEtu qEtp [0ywq] EwEwEiEwE ypEtu qEtp [0ywq] [3wyo] [5wyi] [6oep] [3wyp] [6oep] [8etp] [0etps] [8etpd] [3wyd] [5wys] [6oep] [3wyp] [4qei] [6etu] [0ety]" },
    { name="Moonlight Sonata 3rd — Beethoven",      bpm=60,  emoji="🌕", category="VIP-Classica", sequence="[3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [3qu] [5qu] [6qu] [3qi] [5qi] [6qi] [3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [2qe] [5qe] [6qe] [2qi] [5qi] [6qi] [2qu] [5qu] [6qu] [2qi] [5qi] [6qi] [1qe] [4qe] [6qe] [1qi] [4qi] [6qi] [1qu] [4qu] [6qu] [1qi] [4qi] [6qi] [1qr] [4qr] [5qr] [1qt] [4qt] [5qt] [1qy] [4qy] [5qy] [0qe] [4qe] [6qe] [0qi] [4qi] [6qi] [3qe] [5qe] [6qe] [3qi] [5qi] [6qi] [2qe] [5qe] [6qe] [2qi] [5qi] [6qi] [1qe] [4qe] [6qe] [1qi] [4qi] [6qi]" },
    { name="River Flows in You — Yiruma (Full)",    bpm=72,  emoji="🌊", category="VIP-Classica", sequence="[4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qi] [qi] [qi] [qi] [4qp] [qp] [qp] [qp] [4qp] [qp] [qp] [qp] [4qo] [qo] [qo] [qo] [4qo] [qo] [qo] [qo] [4qi] s d f [4s] s s s [4p] s d f [4p] d s p [4o] p s d [4p] d s p [4i] p s d 4 s d f [4s] d f s [4d] f d s [4p] d s p [4o] s d f [4s] f s d [4d] s p o [4p] o p s [4qi] s d f [4s] s s s [4p] s d f [4p] d s p [4o] p s d [4p] d s p [4i] p s d 4 s d f [4s] d f s [4d] f d s [4p] d s p [4o] s d f [4s] f s d [4d] s p o [4p] o p s" },
    { name="Gurenge — Demon Slayer (Full OP)",       bpm=135, emoji="🔥", category="VIP-Anime",    sequence="[6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [9u] e u y i o [0u] e u y t e [0u] e u y i o [6eu] [6eu] [6ey] [6et] [8eu] [8eu] [8ey] [8et] [9eu] [9eu] [9ey] [9et] [0eu] [0eu] [0ey] [0et] [6u] e u y t e [6u] e u y i o [8u] e u y t e [8u] e u y i o [9u] e u y t e [9u] e u y i o [0u] e u y t e [0u] e u y i o" },
    { name="Shinzou wo Sasageyo — AoT (Full)",       bpm=160, emoji="⚔️", category="VIP-Anime",   sequence="[6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [9s] e s d f g [0s] e s d s e [0s] e s d f g [6es] [6es] [6es] [8es] [8es] [9es] [9es] [0es] [0es] [6s] e s d s e [6s] e s d f g [8s] e s d s e [8s] e s d f g [9s] e s d s e [9s] e s d f g [0s] e s d s e [0s] e s d f g" },
    { name="Bury the Light — DMC5 (Full)",          bpm=155, emoji="⚔️", category="VIP-Games",   sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p u o i [8p] e p o p e [8p] e p u o i [9p] e p o p e [9p] e p u o i [0p] e p o p e [0p] e p u o i [6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p u o i [8p] e p o p e [8p] e p u o i [9p] e p o p e [0p] e p u o i" },
    { name="His Theme — Undertale (Full)",           bpm=75,  emoji="💛", category="VIP-Games",    sequence="[4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [6i] q i p o u [5o] w o i u y [3u] w u y t e [4qi] [4qi] [4qo] [4qp] [6qi] [6qi] [6qo] [6qp] [5qo] [5qo] [5qi] [5qu] [3qu] [3qu] [3qy] [3qt] [4i] q i o p o [4i] q i p s d [6i] q i o p o [6i] q i p o u [5o] w o i u y [3u] w u y t e" },
    { name="Passo Bem Solto — Funk BR (Hard)",       bpm=145, emoji="🎉", category="VIP-Funk",     sequence="a a a S S S d S a I S p p o a a a S S S d S a a a S a a o a S a a a a h G G S o a S a a a a h a [Ga] a [GS] S [dS] d [Sw5] a [I5] G [e6] G [e6] [Su6] [Sr7] a [I7] G [r$] G [r$] [dy$] $ [Sw5] a [I5] G [e6] G [e6] [Su6] [Sr7] a [I7] a [ar$] S [Sr$] [Sy$] [d$] a a a S S S d S a I S p p o a a a S S S d S a a a S a a o a S a a a a h G G S o a S a a a a h a" },
    { name="Blinding Lights — The Weeknd (Extended)",bpm=171, emoji="🌃", category="VIP-Pop",      sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6ep] [8ep] [9ep] [0ep] [6ep] [6epu] [8epu] [9epu] [0epu] [6p] e p u p e [6p] e p u o i [8p] e p u p e [8p] e p u o i [9p] e p u p e [9p] e p u o i [0p] e p u p e [0p] e p u o i [6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6ep] [8ep] [9ep] [0ep] [6ep] [6epu] [8epu] [9epu] [0epu] [6p] e p u p e [6p] e p u o i [8p] e p u p e [8p] e p u o i [9p] e p u p e [9p] e p u o i [0p] e p u p e [0p] e p u o i" },
    { name="Enemy — Imagine Dragons (Full)",        bpm=115, emoji="⚡", category="VIP-Rock",     sequence="[6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [9p] e p o i u [0p] e p o p e [0p] e p o i u [6ep] [6ep] [6ep] [8ep] [8ep] [9ep] [9ep] [0ep] [0ep] [6p] e p o p e [6p] e p o i u [8p] e p o p e [8p] e p o i u [9p] e p o p e [0p] e p o i u" },
    { name="Cruel Summer — Taylor Swift (Extended)", bpm=170, emoji="☀️", category="VIP-Pop",      sequence="[6u] [6u] [6u] [6y] [6t] [6u] [6u] [6u] [6y] [6t] [8u] [8u] [8u] [8y] [8t] [8u] [8u] [8u] [8y] [8t] [9u] [9u] [9u] [9y] [9t] [9u] [9u] [9u] [9y] [9t] [0u] [0u] [0u] [0y] [0t] [0u] [0u] [0u] [0y] [0t] [6tu] [6tu] [6tu] [6ty] [6yt] [6tu] [6tu] [8tu] [8tu] [8tu] [8ty] [8yt] [8tu] [8tu] [9tu] [9tu] [9tu] [9ry] [9yt] [9tu] [9tu] [0tu] [0tu] [0tu] [0ty] [0yt] [0tu] [0tu] [6u] [6u] [6u] [6y] [6t] [6u] [6u] [6u] [6y] [6t] [8u] [8u] [8u] [8y] [8t] [8u] [8u] [8u] [8y] [8t] [9u] [9u] [9u] [9y] [9t] [9u] [9u] [9u] [9y] [9t] [0u] [0u] [0u] [0y] [0t] [0u] [0u] [0u] [0y] [0t]" },
    { name="Astronomia — Coffin Dance (Extended)",  bpm=126, emoji="⚰️", category="VIP-Meme",     sequence="[6ep] [3ep] [6ep] [6ep] [5ep] [2ep] [5ep] [5ep] [4ep] [1ep] [4ep] [4ep] [3ep] [0ep] [3ep] [3ep] [6ep] [3ep] [6pu] [6pu] [5pu] [2pu] [5pu] [5pu] [4pu] [1pu] [4pu] [4pu] [3pu] [0pu] [3pu] [3pu] [6ep] p [3ep] p [6p] u [6pu] u [5ep] p [2ep] p [5p] u [5pu] u [4ep] p [1ep] p [4p] u [4pu] u [3ep] p [0ep] p [3p] u [3pu] u e p u a s d f [6f]-[3f]-[6f]-[6a]- [5s]-[2s]-[5s]-[5a]- [4p]-[1p]-[4p]-[4o]- [3o]-[0o]-[3o]-[3i]- [6ep] [3ep] [6ep] [6ep] [5ep] [2ep] [5ep] [5ep] [4ep] [1ep] [4ep] [4ep] [3ep] [0ep] [3ep] [3ep] [6ep] [3ep] [6pu] [6pu] [5pu] [2pu] [5pu] [5pu] [4pu] [1pu] [4pu] [4pu] [3pu] [0pu] [3pu] [3pu]" },
}
local VIP_UNLOCKED = false

-- ── ABA NO RAYFIELD PRA DIGITAR O CÓDIGO ──
local TabADM = Window:CreateTab("🔐 ADM", nil)
TabADM:CreateSection("Acesso Administrativo")
TabADM:CreateLabel("Digite o codigo secreto para abrir o Painel ADM.")
TabADM:CreateLabel("Apenas moderadores e o dono possuem o codigo.")

local admInputCode = ""
TabADM:CreateInput({
    Name            = "Codigo de Acesso ADM",
    PlaceholderText = "Ex: TV4-ADM-XXXX",
    NumbersOnly     = false,
    RemoveTextAfterFocusLost = false,
    Flag            = "ADMCodeInput",
    Callback        = function(v) admInputCode = v end,
})

TabADM:CreateButton({
    Name     = "🔓  ABRIR PAINEL ADM",
    Callback = function()
        if admInputCode ~= ADM_CODE then
            Rayfield:Notify({ Title="❌ Acesso Negado", Content="Codigo incorreto!", Duration=3 })
            return
        end
        if admPanelOpen then
            Rayfield:Notify({ Title="ADM", Content="Painel ja esta aberto!", Duration=2 })
            return
        end
        openADMPanel()
    end,
})

-- ── FUNCAO AUXILIAR: DRAGGABLE ──
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ── FUNCAO PRINCIPAL DO PAINEL ADM (ScreenGui = touch funcional) ──
function openADMPanel()
    admPanelOpen = true
    local plr = LocalPlayer

    -- ScreenGui é mais confiavel que BillboardGui para touch/click
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name             = "TalentlessADMGui"
    screenGui.ResetOnSpawn     = false
    screenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    screenGui.Parent           = plr:WaitForChild("PlayerGui")
    admGuiAberto = screenGui

    -- Frame principal centralizado
    local mainFrame = Instance.new("Frame")
    mainFrame.Name             = "MainFrame"
    mainFrame.Size             = UDim2.new(0, 360, 0, 480)
    mainFrame.Position           = UDim2.new(0.5, -180, 0.5, -240)
    mainFrame.BackgroundColor3   = Color3.fromRGB(10, 10, 18)
    mainFrame.BorderSizePixel    = 0
    mainFrame.ClipsDescendants   = true
    mainFrame.Active             = true
    mainFrame.Parent             = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(180, 0, 255)
    stroke.Thickness = 2
    stroke.Parent    = mainFrame

    -- ── ANIMAÇÃO DE ENTRADA ──
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tweenIn = TweenService:Create(mainFrame,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 360, 0, 480), Position = UDim2.new(0.5, -180, 0.5, -240) }
    )
    tweenIn:Play()

    -- ── TÍTULO / HANDLE DE DRAG ──
    local titleBar = Instance.new("Frame")
    titleBar.Name              = "TitleBar"
    titleBar.Size              = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3  = Color3.fromRGB(120, 0, 200)
    titleBar.BorderSizePixel   = 0
    titleBar.Active            = true
    titleBar.Parent            = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 14)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size              = UDim2.new(1, -80, 1, 0)
    titleLabel.Position          = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text              = "🔐  Talentless ADM Panel"
    titleLabel.TextColor3        = Color3.fromRGB(255, 255, 255)
    titleLabel.Font              = Enum.Font.GothamBold
    titleLabel.TextSize          = 13
    titleLabel.TextXAlignment    = Enum.TextXAlignment.Left
    titleLabel.Parent            = titleBar

    -- Botão fechar
    local btnClose = Instance.new("TextButton")
    btnClose.Name              = "BtnClose"
    btnClose.Size              = UDim2.new(0, 28, 0, 28)
    btnClose.Position          = UDim2.new(1, -34, 0, 5)
    btnClose.BackgroundColor3  = Color3.fromRGB(200, 30, 30)
    btnClose.Text              = "✕"
    btnClose.TextColor3        = Color3.fromRGB(255, 255, 255)
    btnClose.Font              = Enum.Font.GothamBold
    btnClose.TextSize          = 14
    btnClose.BorderSizePixel   = 0
    btnClose.AutoButtonColor   = false
    btnClose.Active            = true
    btnClose.Parent            = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = btnClose

    -- Botão minimizar
    local btnMin = Instance.new("TextButton")
    btnMin.Name             = "BtnMin"
    btnMin.Size             = UDim2.new(0, 28, 0, 28)
    btnMin.Position         = UDim2.new(1, -66, 0, 5)
    btnMin.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
    btnMin.Text             = "—"
    btnMin.TextColor3       = Color3.fromRGB(255, 255, 255)
    btnMin.Font             = Enum.Font.GothamBold
    btnMin.TextSize         = 14
    btnMin.BorderSizePixel  = 0
    btnMin.AutoButtonColor  = false
    btnMin.Active           = true
    btnMin.Parent           = titleBar

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = btnMin

    -- ÁREA DE CONTEÚDO
    local contentFrame = Instance.new("Frame")
    contentFrame.Name              = "Content"
    contentFrame.Size              = UDim2.new(1, -16, 1, -50)
    contentFrame.Position          = UDim2.new(0, 8, 0, 44)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent            = mainFrame

    -- Layout dos botões principais
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding   = UDim.new(0, 6)
    listLayout.Parent    = contentFrame

    -- Painel de detalhes (abaixo dos botões principais)
    local detailFrame = Instance.new("Frame")
    detailFrame.Name             = "DetailFrame"
    detailFrame.Size             = UDim2.new(1, 0, 1, -110)
    detailFrame.Position         = UDim2.new(0, 0, 0, 108)
    detailFrame.BackgroundColor3 = Color3.fromRGB(18, 8, 30)
    detailFrame.BorderSizePixel  = 0
    detailFrame.Visible          = false
    detailFrame.Active           = true
    detailFrame.Parent           = contentFrame

    local detailCorner = Instance.new("UICorner")
    detailCorner.CornerRadius = UDim.new(0, 10)
    detailCorner.Parent = detailFrame

    local detailScroll = Instance.new("ScrollingFrame")
    detailScroll.Name               = "DetailScroll"
    detailScroll.Size               = UDim2.new(1, -8, 1, -8)
    detailScroll.Position           = UDim2.new(0, 4, 0, 4)
    detailScroll.BackgroundTransparency = 1
    detailScroll.BorderSizePixel    = 0
    detailScroll.ScrollBarThickness = 4
    detailScroll.ScrollingEnabled   = true
    detailScroll.CanvasSize         = UDim2.new(0, 0, 0, 0)
    detailScroll.Active             = true
    detailScroll.Parent             = detailFrame

    local detailLayout = Instance.new("UIListLayout")
    detailLayout.SortOrder    = Enum.SortOrder.LayoutOrder
    detailLayout.Padding      = UDim.new(0, 5)
    detailLayout.Parent       = detailScroll

    -- Função utilitária para adicionar linha
    local function addDetailLine(txt, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.new(1, -8, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text              = txt
        lbl.TextColor3        = color or Color3.fromRGB(220, 220, 255)
        lbl.Font              = Enum.Font.Gotham
        lbl.TextSize          = 11
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.TextWrapped       = true
        lbl.LayoutOrder       = #detailScroll:GetChildren() + 1
        lbl.Parent            = detailScroll
        task.wait()
        detailScroll.CanvasSize = UDim2.new(0, 0, 0, detailLayout.AbsoluteContentSize.Y + 20)
        return lbl
    end

    local function addDetailButton(txt, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.new(1, -8, 0, 26)
        btn.BackgroundColor3  = color or Color3.fromRGB(60, 0, 100)
        btn.Text              = txt
        btn.TextColor3        = Color3.fromRGB(230, 200, 255)
        btn.Font              = Enum.Font.GothamBold
        btn.TextSize          = 11
        btn.BorderSizePixel   = 0
        btn.AutoButtonColor   = false
        btn.Active            = true
        btn.LayoutOrder       = #detailScroll:GetChildren() + 1
        btn.Parent            = detailScroll

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        local function flash()
            TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(140, 0, 240) }):Play()
            task.wait(0.12)
            TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = color or Color3.fromRGB(60, 0, 100) }):Play()
        end

        -- Suporte a PC e Touch
        btn.MouseButton1Click:Connect(function() flash() pcall(callback) end)
        btn.Activated:Connect(function() flash() pcall(callback) end)

        task.wait()
        detailScroll.CanvasSize = UDim2.new(0, 0, 0, detailLayout.AbsoluteContentSize.Y + 20)
        return btn
    end

    local function clearDetail()
        for _, c in ipairs(detailScroll:GetChildren()) do
            if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("Frame") then
                c:Destroy()
            end
        end
        detailScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    end

    local function animateBtn(btn, col)
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundColor3 = col }):Play()
    end

    -- ── OS 4 BOTÕES PRINCIPAIS ──
    local btnData = {
        { label = "⚡  Comandos ADM",    color = Color3.fromRGB(100, 0, 200) },
        { label = "👥  Players Online",  color = Color3.fromRGB(0, 120, 180) },
        { label = "📋  Creditos / Info", color = Color3.fromRGB(20, 140, 60) },
        { label = "💎  Musicas VIP",      color = Color3.fromRGB(200, 140, 0) },
    }

    for idx, bdata in ipairs(btnData) do
        local btn = Instance.new("TextButton")
        btn.Name              = "Btn" .. idx
        btn.Size              = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3  = bdata.color
        btn.Text              = bdata.label
        btn.TextColor3        = Color3.fromRGB(255, 255, 255)
        btn.Font              = Enum.Font.GothamBold
        btn.TextSize          = 12
        btn.BorderSizePixel   = 0
        btn.AutoButtonColor   = false
        btn.Active            = true
        btn.LayoutOrder       = idx
        btn.Parent            = contentFrame

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 8)
        bCorner.Parent = btn

        btn.MouseEnter:Connect(function() animateBtn(btn, bdata.color:Lerp(Color3.fromRGB(255,255,255), 0.15)) end)
        btn.MouseLeave:Connect(function() animateBtn(btn, bdata.color) end)

        local function onClick()
            TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad), { BackgroundColor3 = Color3.fromRGB(255,255,255) }):Play()
            task.wait(0.08)
            animateBtn(btn, bdata.color)

            clearDetail()
            detailFrame.Visible = true
            detailFrame.BackgroundTransparency = 1
            TweenService:Create(detailFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.25 }):Play()

            if idx == 1 then
                -- COMANDOS ADM FUNCIONAIS
                addDetailLine("⚡ COMANDOS ADMINISTRATIVOS", Color3.fromRGB(200, 150, 255))
                addDetailLine("─────────────────────────", Color3.fromRGB(100,100,150))

                local cmds = {
                    { name="▶  Tocar Musica Atual",   fn=function() startPlayback(); refreshPlayerLabels() end },
                    { name="⏸  Pause / Resume",        fn=function() pauseResume(); refreshPlayerLabels() end },
                    { name="⏹  Parar Tudo",            fn=function() stopPlayback(); refreshPlayerLabels() end },
                    { name="⏭  Proxima Musica",        fn=function() nextSong(); refreshPlayerLabels() end },
                    { name="⏮  Musica Anterior",       fn=function() prevSong(); refreshPlayerLabels() end },
                    { name="🔁  Toggle Loop",          fn=function() State.loopEnabled = not State.loopEnabled; Rayfield:Notify({Title="Loop",Content=State.loopEnabled and "Ativado" or "Desativado",Duration=2}) end },
                    { name="🔀  Toggle Shuffle",        fn=function() State.shuffleEnabled = not State.shuffleEnabled; Rayfield:Notify({Title="Shuffle",Content=State.shuffleEnabled and "Ativado" or "Desativado",Duration=2}) end },
                    { name="🌊  Toggle Reverb",        fn=function() State.reverbEnabled = not State.reverbEnabled; Rayfield:Notify({Title="Reverb",Content=State.reverbEnabled and "Ativado" or "Desativado",Duration=2}) end },
                    { name="🔁  Toggle Delay/Echo",    fn=function() State.delayEnabled = not State.delayEnabled; Rayfield:Notify({Title="Delay",Content=State.delayEnabled and "Ativado" or "Desativado",Duration=2}) end },
                    { name="⚡  Modo Nightcore",       fn=function() State.mode = "Nightcore"; Rayfield:Notify({Title="Modo",Content="Nightcore",Duration=2}) end },
                    { name="🌙  Modo Slowed+Reverb",   fn=function() State.mode = "Slowed"; State.reverbEnabled = true; Rayfield:Notify({Title="Modo",Content="Slowed + Reverb",Duration=2}) end },
                    { name="🎵  Modo Normal",          fn=function() State.mode = "Normal"; State.reverbEnabled = false; State.delayEnabled = false; Rayfield:Notify({Title="Modo",Content="Normal",Duration=2}) end },
                    { name="💨  Velocidade 2x",      fn=function() State.speed = 2.0; Rayfield:Notify({Title="Speed",Content="2.0x",Duration=2}) end },
                    { name="🐢  Velocidade 0.5x",      fn=function() State.speed = 0.5; Rayfield:Notify({Title="Speed",Content="0.5x",Duration=2}) end },
                    { name="↺  Reset Velocidade",      fn=function() State.speed = 1.0; Rayfield:Notify({Title="Speed",Content="1.0x resetado",Duration=2}) end },
                    { name="🗑  Zerar Performance",  fn=function() resetPerformance(); Rayfield:Notify({Title="Performance",Content="Zerada!",Duration=2}) end },
                    { name="🎯  Auto-Play Infinito",   fn=function()
                        Rayfield:Notify({Title="Auto-Play",Content="Iniciando playlist infinita...",Duration=3})
                        stopPlayback(); State.loopEnabled = false; State.shuffleEnabled = true; startPlayback()
                    end },
                    { name="🎹  Preset Concert Hall",  fn=function()
                        State.reverbEnabled = true; State.reverbLevel = 0.45; State.delayEnabled = false
                        Rayfield:Notify({Title="Preset",Content="Piano Sala de Concerto",Duration=3})
                    end },
                    { name="🌌  Preset Lofi",          fn=function()
                        State.reverbEnabled = true; State.reverbLevel = 0.3; State.delayEnabled = true; State.delayTime = 0.2; State.mode = "Slowed"
                        Rayfield:Notify({Title="Preset",Content="Lofi Slowed+Reverb",Duration=3})
                    end },
                }
                for _, cmd in ipairs(cmds) do
                    addDetailButton(cmd.name, Color3.fromRGB(60, 0, 100), cmd.fn)
                end

            elseif idx == 2 then
                -- PLAYERS ONLINE
                addDetailLine("👥 PLAYERS DETECTADOS", Color3.fromRGB(100, 200, 255))
                addDetailLine("─────────────────────────", Color3.fromRGB(80,130,160))
                local plrs = Players:GetPlayers()
                addDetailLine("Total: " .. #plrs .. " jogadores", Color3.fromRGB(180, 220, 255))
                addDetailLine("", nil)
                for _, p in ipairs(plrs) do
                    local isLocal = (p == LocalPlayer) and " ← VOCE" or ""
                    local char2 = p.Character
                    local alive = char2 and char2:FindFirstChild("Humanoid") and char2.Humanoid.Health > 0
                    local status = alive and "Vivo" or "Morto"
                    addDetailLine("• " .. p.Name .. isLocal, Color3.fromRGB(200, 240, 200))
                    addDetailLine("  " .. status .. " | ID: " .. p.UserId, Color3.fromRGB(150, 180, 150))
                    addDetailLine("─", Color3.fromRGB(60, 80, 60))
                end
                addDetailButton("🔄 Atualizar Lista", Color3.fromRGB(0, 100, 160), function()
                    btn.MouseButton1Click:Fire()
                end)

            elseif idx == 3 then
                -- CRÉDITOS
                addDetailLine("📋 TALENTLESS V4 — NEXUS EDITION", Color3.fromRGB(255, 220, 100))
                addDetailLine("─────────────────────────", Color3.fromRGB(140, 120, 60))
                addDetailLine("Versao: " .. VERSION.full, Color3.fromRGB(255, 240, 180))
                addDetailLine("Codename: " .. VERSION.codename, Color3.fromRGB(220, 200, 150))
                addDetailLine("Musicas Free: " .. TOTAL_SONGS, Color3.fromRGB(200, 180, 130))
                addDetailLine("Musicas VIP: " .. #VIP_SONGS, Color3.fromRGB(255, 200, 50))
                addDetailLine("", nil)
                addDetailLine("MODERADORES / STAFF:", Color3.fromRGB(180, 120, 255))
                for _, m in ipairs(ADM_MODERADORES) do
                    addDetailLine(m.emoji .. " " .. m.nome .. " — " .. m.cargo, Color3.fromRGB(210, 170, 255))
                end
                addDetailLine("", nil)
                addDetailLine("DESENVOLVEDORES:", Color3.fromRGB(100, 200, 255))
                for _, d in ipairs(ADM_DEVS) do
                    addDetailLine(d.emoji .. " " .. d.nome .. " — " .. d.cargo, Color3.fromRGB(160, 210, 255))
                end
                addDetailLine("", nil)
                addDetailLine("Painel ADM — Acesso Pago / Exclusivo", Color3.fromRGB(255, 180, 0))
                addDetailLine("Comandos de piano exclusivos ativos!", Color3.fromRGB(200, 255, 200))

            elseif idx == 4 then
                -- MÚSICAS VIP EXCLUSIVAS
                addDetailLine("💎 MUSICAS VIP EXCLUSIVAS", Color3.fromRGB(255, 200, 50))
                addDetailLine("─────────────────────────", Color3.fromRGB(140, 120, 60))
                addDetailLine("Essas musicas NAO existem na versao free!", Color3.fromRGB(255, 220, 100))
                addDetailLine("Status: " .. (VIP_UNLOCKED and "✅ INJETADAS" or "❌ NAO INJETADAS"), VIP_UNLOCKED and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100))
                addDetailLine("", nil)

                addDetailButton("💎 INJETAR TODAS AS MUSICAS VIP", Color3.fromRGB(180, 120, 0), function()
                    if VIP_UNLOCKED then
                        Rayfield:Notify({ Title="VIP", Content="Musicas VIP ja estao no banco!", Duration=3 })
                        return
                    end
                    for _, vs in ipairs(VIP_SONGS) do
                        table.insert(Songs, vs)
                    end
                    TOTAL_SONGS = #Songs
                    VIP_UNLOCKED = true
                    Rayfield:Notify({ Title="💎 VIP ATIVADO!", Content=#VIP_SONGS .. " musicas exclusivas injetadas! Total: " .. TOTAL_SONGS, Duration=5 })
                end)

                addDetailLine("", nil)
                addDetailLine("Tocar VIP individualmente:", Color3.fromRGB(220, 180, 255))
                for i, vs in ipairs(VIP_SONGS) do
                    addDetailButton("▶ " .. vs.emoji .. " " .. vs.name, Color3.fromRGB(80, 50, 0), function()
                        if not VIP_UNLOCKED then
                            Rayfield:Notify({ Title="VIP", Content="Injete as musicas VIP primeiro!", Duration=3 })
                            return
                        end
                        local realIdx = TOTAL_SONGS - #VIP_SONGS + i
                        stopPlayback()
                        State.currentSong = realIdx
                        refreshPlayerLabels()
                        startPlayback()
                        Rayfield:Notify({ Title="VIP Tocando", Content=vs.name, Duration=4 })
                    end)
                end

                addDetailLine("", nil)
                addDetailButton("💾  Salvar Todas as VIP no Custom", Color3.fromRGB(100, 0, 160), function()
                    if not VIP_UNLOCKED then
                        Rayfield:Notify({ Title="VIP", Content="Injete primeiro!", Duration=2 })
                        return
                    end
                    for _, vs in ipairs(VIP_SONGS) do
                        table.insert(State.customSongs, vs)
                    end
                    saveCustomSongs()
                    Rayfield:Notify({ Title="VIP", Content="Todas as VIP salvas em Custom!", Duration=3 })
                end)
            end
        end

        btn.MouseButton1Click:Connect(onClick)
        btn.Activated:Connect(onClick)
    end

    -- Draggable pelo título
    makeDraggable(mainFrame, titleBar)

    -- ── BOTÃO FECHAR ──
    local function closePanel()
        local tweenOut = TweenService:Create(mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }
        )
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            screenGui:Destroy()
            admPanelOpen = false
            admGuiAberto = nil
            Rayfield:Notify({ Title="ADM", Content="Painel fechado.", Duration=2 })
        end)
    end
    btnClose.MouseButton1Click:Connect(closePanel)
    btnClose.Activated:Connect(closePanel)

    -- ── BOTÃO MINIMIZAR ──
    local minimizado = false
    local function toggleMin()
        minimizado = not minimizado
        local targetH = minimizado and 0.12 or 1
        TweenService:Create(mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, 360, targetH, minimizado and 0 or 480) }
        ):Play()
        contentFrame.Visible = not minimizado
        btnMin.Text = minimizado and "▲" or "—"
    end
    btnMin.MouseButton1Click:Connect(toggleMin)
    btnMin.Activated:Connect(toggleMin)

    Rayfield:Notify({
        Title   = "🔐 Painel ADM Aberto!",
        Content = "Bem-vindo, " .. plr.Name .. "! Acesso autorizado.",
        Duration = 4,
    })
end

-- ══════════════════════════════════════════════════════════════
--  FIM DO PAINEL ADM
-- ══════════════════════════════════════════════════════════════

print("═══════════════════════════════════════════════════════════")
print("  TALENTLESS V4 — MEGA EDITION (Rayfield)")
print("  Versao: " .. VERSION.full .. " — Codename: " .. VERSION.codename)
print("  Musicas: " .. TOTAL_SONGS .. " | Custom salvas: " .. #State.customSongs)
print("  Devs: Beicon_129 (333), Dkgune (Rdd), Davi Scripts, C00Ikiddban")
print("  F2=Play/Pause | F3=Stop | F4=Next | F5=Prev")
print("  F6=Loop | F7=Shuffle | F8=Humanize | F9=Loop Trecho")
print("  NOVO V4: Dueto, Efeitos, Codigo, Performance, Sertanejo!")
print("  PAINEL ADM: ScreenGui draggable + Touch + Musicas VIP exclusivas!")
print("═══════════════════════════════════════════════════════════")
