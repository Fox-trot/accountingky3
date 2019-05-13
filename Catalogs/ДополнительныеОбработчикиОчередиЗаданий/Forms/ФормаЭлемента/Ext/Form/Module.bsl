﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Использование = Истина;
	КонецЕсли;
	
	Если Расписание = Неопределено Тогда
		Расписание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ОбработкаОчередиЗаданийБТС).Расписание;
	КонецЕсли;
	
	Элементы.МетодыМетод.СписокВыбора.ЗагрузитьЗначения(ОчередьЗаданийБТС.ВозможныеМетоды());
	
	Элементы.ДекорацияЗапретРедактирования.Видимость = Объект.Авто;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РегламентноеЗадание = Справочники.ДополнительныеОбработчикиОчередиЗаданий.РегламентноеЗадание(ТекущийОбъект.Ссылка);
	
	Если РегламентноеЗадание <> Неопределено Тогда
		Расписание = РегламентноеЗадание.Расписание;
		Использование = РегламентноеЗадание.Использование;
	КонецЕсли;
	
	ТолькоПросмотр = ТекущийОбъект.Авто;
	Элементы.Расписание.Доступность = Не ТекущийОбъект.Авто;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Расписание);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", Использование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РасписаниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ЗавершениеРедактированияРасписания", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершениеРедактированияРасписания(НовоеРасписание, ДополнительныеПараметры) Экспорт
	
	Если НовоеРасписание <> Неопределено И Не ТолькоПросмотр Тогда
		Расписание = НовоеРасписание;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
