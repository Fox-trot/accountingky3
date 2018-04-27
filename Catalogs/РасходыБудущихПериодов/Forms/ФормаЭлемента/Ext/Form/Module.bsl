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
	
	Если Параметры.Ключ.Пустая() Тогда
		БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
			ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Себестоимость.
//
&НаКлиенте
Процедура СебестоимостьПриИзменении(Элемент)
	Объект.Сумма = Объект.Себестоимость + Объект.СуммаНДС
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаНачалаСписания.
//
&НаКлиенте
Процедура ДатаНачалаСписанияПриИзменении(Элемент)
	Объект.ДатаНачалаСписания = НачалоМесяца(Объект.ДатаНачалаСписания);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДатаОкончанияСписания.
//
&НаКлиенте
Процедура ДатаОкончанияСписанияПриИзменении(Элемент)
	Объект.ДатаОкончанияСписания = КонецМесяца(Объект.ДатаОкончанияСписания);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СуммаНДС.
//
&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)
	Объект.Сумма = Объект.Себестоимость + Объект.СуммаНДС
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СчетУчета.
//
&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто1.
//
&НаКлиенте
Процедура Субконто1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто1.
//
&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто2.
//
&НаКлиенте
Процедура Субконто2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто2.
//
&НаКлиенте
Процедура Субконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Субконто3.
//
&НаКлиенте
Процедура Субконто3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Субконто3.
//
&НаКлиенте
Процедура Субконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)

	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, Объект, НомерСубконто, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Объект, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"Субконто", "Субконто", "СчетУчета");
	Результат.ДопРеквизиты.Вставить("Организация", БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
	
	Возврат Результат;

КонецФункции

#КонецОбласти