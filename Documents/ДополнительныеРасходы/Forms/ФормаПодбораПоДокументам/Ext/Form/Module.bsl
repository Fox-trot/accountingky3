﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	АдресДокументовВХранилище = ЗаписатьПодборВХранилище(Значение);
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("АдресДокументовВХранилище", АдресДокументовВХранилище);
	
	Оповестить("ПодборПоДокументамПроизведен", ПараметрыПодбора, УникальныйИдентификаторФормыВладельца);
	
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Функция помещает результаты подбора в хранилище
//
Функция ЗаписатьПодборВХранилище(Значение) 
	
	Возврат ПоместитьВоВременноеХранилище(Значение, УникальныйИдентификаторФормыВладельца);
	
КонецФункции //ЗаписатьПодборВХранилище() 

#КонецОбласти