﻿
#Область ПрограммныйИнтерфейс

// Открывает отчет по всем проблемам переданного вида проблем.
//
// Параметры:
//   ВидПроверок - СправочникСсылка.ВидыПроверок - ссылка на вид проверки.
//               - Строка - строковый идентификатор вида проверки Свойство1.
//               - Массив - строковые идентификаторы вида проверки Свойство1...СвойствоN.
//
// Пример:
//   ОткрытьОтчетПоПроблемам("СистемныеПроверки");
//
Процедура ОткрытьОтчетПоПроблемам(ВидПроверок) Экспорт
	
	// Проверка валидности переданного параметра ВидПроверок осуществляется
	// в процедуре ПриСозданииНаСервере модуля отчета РезультатыПроверкиУчета.
	
	КонтрольВеденияУчетаСлужебныйКлиент.ОткрытьОтчетПоПроблемам(ВидПроверок);
	
КонецПроцедуры

// Открывает форму отчета при нажатии на гиперссылку, сигнализирующую о наличии проблем.
//
//  Параметры:
//     Форма                - УправляемаяФорма - Управляемая форма проблемного объекта.
//     ПроблемныйОбъект     - СсылкаНаОбъект - Ссылка на проблемный объект.
//     СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения
//                            стандартной (системной) обработки события.
//
// Пример:
//    КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
//
Процедура ОткрытьОтчетПоПроблемамОбъекта(Форма, ПроблемныйОбъект, СтандартнаяОбработка) Экспорт
	
	// Проверка валидности переданных параметров Форма, ПроблемныйОбъект, СтандартнаяОбработка
	// в процедуре ПриСозданииНаСервере модуля отчета РезультатыПроверкиУчета.
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СсылкаНаОбъект", ПроблемныйОбъект);
	
	ОткрытьФорму("Отчет.РезультатыПроверкиУчета.Форма", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму отчета при двойном нажатии на ячейку таблицы формы списка с картинкой,
// сигнализирующей о наличии проблем с выделенным объектом.
//
//  Параметры:
//     Форма                   - УправляемаяФорма - Управляемая форма проблемного объекта.
//     ИмяСписка               - Строка - Имя целевого динамического списка как реквизита формы.
//     Поле                    - ПолеФормы - Колонка в которой располагается картинка,
//                               сигнализирующая о наличии проблем.
//     СтандартнаяОбработка    - Булево - В данный параметр передается признак выполнения
//                               стандартной (системной) обработки события.
//     ДополнительныеПараметры - Структура, Неопределено - Содержит дополнительные свойства в случае
//                               необходимости их использования.
//
// Пример:
//    КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
//
Процедура ОткрытьОтчетПоПроблемамИзСписка(Форма, ИмяСписка, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	ИмяПроцедуры = "КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамИзСписка";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Форма", Форма, Тип("УправляемаяФорма"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИмяСписка", ИмяСписка, Тип("Строка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Поле", Поле, Тип("ПолеФормы"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "СтандартнаяОбработка", СтандартнаяОбработка, Тип("Булево"));
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ДополнительныеПараметры", ДополнительныеПараметры, Тип("Структура"));
	КонецЕсли;
	
	ДополнительныеСвойства = Форма[ИмяСписка].КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	Если Не (ДополнительныеСвойства.Свойство("КолонкаИндикатора")
		И ДополнительныеСвойства.Свойство("ВидОбъектаМетаданных")
		И ДополнительныеСвойства.Свойство("ИмяОбъектаМетаданных")
		И ДополнительныеСвойства.Свойство("ИмяСписка")) Тогда
		СтандартнаяОбработка = Истина;
	Иначе
		
		ТаблицаФормы   = Форма.Элементы.Найти(ДополнительныеСвойства.ИмяСписка);
		КолонкаИндикатора = ДополнительныеСвойства.КолонкаИндикатора;
		
		Если Поле.Имя <> КолонкаИндикатора Тогда
			СтандартнаяОбработка = Истина;
		Иначе
			СтандартнаяОбработка = Ложь;
			
			ДанныеКонтекста = Новый Структура;
			ДанныеКонтекста.Вставить("ВыделенныеСтроки",     ТаблицаФормы.ВыделенныеСтроки);
			ДанныеКонтекста.Вставить("ВидОбъектаМетаданных", ДополнительныеСвойства.ВидОбъектаМетаданных);
			ДанныеКонтекста.Вставить("ИмяОбъектаМетаданных", ДополнительныеСвойства.ИмяОбъектаМетаданных);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ДанныеКонтекста", ДанныеКонтекста);
			ОткрытьФорму("Отчет.РезультатыПроверкиУчета.Форма", ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
