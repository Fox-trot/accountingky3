﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.ПланыСчетов.Хозрасчетный);
	Элементы.ЗаписатьИЗакрыть.Видимость = НЕ ТолькоПросмотр;
	
	ПараметрыУчета = ОбщегоНазначенияБПСервер.ОпределитьПараметрыУчета();
	
	УчетПроизводстваПоЗаказам = ПолучитьФункциональнуюОпцию("УчетПроизводстваПоЗаказам");
	УчетПроизводстваПоЗаказамИсходноеЗначение = УчетПроизводстваПоЗаказам;
	УчетПроизводстваПоНоменклатурнымГруппам = ПолучитьФункциональнуюОпцию("УчетПроизводстваПоНоменклатурнымГруппам");
	УчетПроизводстваПоНоменклатурнымГруппамИсходноеЗначение = УчетПроизводстваПоНоменклатурнымГруппам;
	ИспользоватьНесколькоНоменклатурныхГрупп = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоНоменклатурныхГрупп");
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчетПроизводстваПоЗаказамПриИзменении(Элемент)
	
	Если УчетПроизводстваПоЗаказам 
		И УчетПроизводстваПоНоменклатурнымГруппам Тогда 
		
		ТекстСообщения = НСтр("ru = 'Для влючения ""Учета производства по заказам"" сначала следует отключить ""Учет производства по номенклатурным группам"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "УчетПроизводстваПоНоменклатурнымГруппам");
		УчетПроизводстваПоЗаказам = Ложь;
		Возврат;		
	КонецЕсли;	
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура УчетПроизводстваПоНоменклатурнымГруппамПриИзменении(Элемент)
	
	Если УчетПроизводстваПоЗаказам 
		И УчетПроизводстваПоНоменклатурнымГруппам Тогда 
		
		ТекстСообщения = НСтр("ru = 'Для влючения ""Учета производства по номенклатурным группам"" сначала следует отключить ""Учет производства по заказам"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "УчетПроизводстваПоЗаказам");
		УчетПроизводстваПоНоменклатурнымГруппам = Ложь;
		Возврат;		
	КонецЕсли;	
	
	Если Не УчетПроизводстваПоНоменклатурнымГруппам Тогда 
		ИспользоватьНесколькоНоменклатурныхГрупп = Ложь;
	КонецЕсли;	
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИзменения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если УчетПроизводстваПоНоменклатурнымГруппам Тогда 
		Элементы.ИспользоватьНесколькоНоменклатурныхГрупп.ТолькоПросмотр = Ложь;
	Иначе 
		Элементы.ИспользоватьНесколькоНоменклатурныхГрупп.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Будет изменено субконто.
	Если (НЕ УчетПроизводстваПоЗаказам = УчетПроизводстваПоЗаказамИсходноеЗначение)
		Или (НЕ УчетПроизводстваПоНоменклатурнымГруппам = УчетПроизводстваПоНоменклатурнымГруппамИсходноеЗначение) Тогда 
		Элементы.ГруппаПредупреждениеАктивно.Видимость = Истина;
	Иначе
		Элементы.ГруппаПредупреждениеАктивно.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ВопросПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПрименитьНастройкуСубконто();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	ПараметрыУчета.УчетПроизводстваПоЗаказам = УчетПроизводстваПоЗаказам;
	ПараметрыУчета.УчетПроизводстваПоНоменклатурнымГруппам = УчетПроизводстваПоНоменклатурнымГруппам;
	
	ТекстВопроса = ОбщегоНазначенияБПВызовСервера.ПолучитьТекстВопросаПриУдаленииСубконто(ПараметрыУчета);
	Если ПустаяСтрока(ТекстВопроса) Тогда
		ПрименитьНастройкуСубконто();
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПередЗаписьюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройкуСубконто(Отказ = Ложь)
	
	ПрименитьНастройкуСубконтоНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Оповестить("ИзменениеНастройкиПланаСчетов");
		Оповестить("ИзменениеНастроекПараметровУчета");
		Оповестить("Запись_НаборКонстант");
		ОповеститьОбИзменении(Тип("ПланСчетовСсылка.Хозрасчетный"));
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменены параметры субконто'"), 
			"e1cib/app/Обработка.ЖурналРегистрации", "Журнал регистрации");
		ОбновитьИнтерфейс();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкуСубконтоНаСервере(Отказ = Ложь)
	
	ДополнительныеПараметры = ОбщегоНазначенияБПСервер.ПолучитьСтруктуруДополнительныхПараметров();
	ДополнительныеПараметры.УчетПроизводства = Истина;
	ОбщегоНазначенияБПСервер.ПрименитьПараметрыУчета(ПараметрыУчета, ДополнительныеПараметры, Истина, Отказ);
	
	Константы.ФункциональнаяОпцияУчетПроизводстваПоЗаказам.Установить(УчетПроизводстваПоЗаказам);
	Константы.ФункциональнаяОпцияУчетПроизводстваПоНоменклатурнымГруппам.Установить(УчетПроизводстваПоНоменклатурнымГруппам);
	Константы.ИспользоватьНесколькоНоменклатурныхГрупп.Установить(ИспользоватьНесколькоНоменклатурныхГрупп);
	
КонецПроцедуры

#КонецОбласти
