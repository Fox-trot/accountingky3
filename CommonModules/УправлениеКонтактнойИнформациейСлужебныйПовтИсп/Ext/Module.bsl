﻿#Область СлужебныеПроцедурыИФункции

// Определяет наличие доступности подсистемы АдресныйКлассификатор и наличие записей о регионах в регистре сведений
// АдресныеОбъекты.
//
Функция СведенияОДоступностиАдресногоКлассификатора() Экспорт
	ЕстьКлассификатор = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор");
	Если ЕстьКлассификатор И НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
		Возврат МодульАдресныйКлассификаторСлужебный.СведенияОДоступностиАдресныхСведений();
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает значение перечисления тип вида контактной информации.
//
//  Параметры:
//    ВидИнформации - СправочникСсылка.ВидыКонтактнойИнформации, Структура - источник данных.
//
Функция ТипВидаКонтактнойИнформации(Знач ВидИнформации) Экспорт
	Результат = Неопределено;
	
	Тип = ТипЗнч(ВидИнформации);
	Если Тип = Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		Результат = ВидИнформации;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидИнформации, "Тип");
	ИначеЕсли ВидИнформации <> Неопределено Тогда
		Данные = Новый Структура("Тип");
		ЗаполнитьЗначенияСвойств(Данные, ВидИнформации);
		Результат = Данные.Тип;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
