﻿
Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	СотрудникиКлиентБазовый.ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
КонецПроцедуры

Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	СотрудникиКлиентБазовый.ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт
	СотрудникиКлиентБазовый.ДокументыФизическихЛицВидДокументаПриИзменении(Форма);
КонецПроцедуры