﻿#Область ПрограммныйИнтерфейс

// Удаляет из массива ссылки на объекты, к которым у пользователя нет доступа
// Параметры:
//  МассивСсылок  - Массив - массив ссылок, из которого надо удалить те, к которым нет доступа
//
Процедура УдалитьНедоступныеЭлементыИзМассива(МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	ОбъектыПоТипам = Новый Соответствие;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат;
	КонецЕсли;
	
	// Исключим из массива объекты  на чтение которых у пользователя нет прав по ролям.
	Для каждого Ссылка Из МассивСсылок Цикл
		Если ПравоДоступа("Чтение", Ссылка.Метаданные()) Тогда
			СсылкиЭтогоТипа = ОбъектыПоТипам[Ссылка.Метаданные()];
			Если СсылкиЭтогоТипа = Неопределено Тогда
				СсылкиЭтогоТипа = Новый Массив;
				ОбъектыПоТипам.Вставить(Ссылка.Метаданные(), СсылкиЭтогоТипа);
			КонецЕсли;
			СсылкиЭтогоТипа.Добавить(Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	// С помощью запроса определим объекты, разрешенные по RLS.
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.ПакетЗапросов[0].ВыбиратьРазрешенные = Истина;
	Индекс = 0;
	Для каждого Объекты Из ОбъектыПоТипам Цикл
		
		Если Индекс = 0 Тогда
			// Оператор с индексом [0] создается конструктором схемы запроса всегда.
			Оператор = СхемаЗапроса.ПакетЗапросов[0].Операторы[0];
		Иначе
			Оператор = СхемаЗапроса.ПакетЗапросов[0].Операторы.Добавить();
		КонецЕсли;
		
		ИмяПараметра = СтрШаблон("МассивОбъектов_%1", Формат(Индекс + 1, "ЧГ=0"));
		
		Оператор.ВыбиратьРазличные = Истина;
		Оператор.Источники.Добавить(Объекты.Ключ.ПолноеИмя());
		Оператор.ВыбираемыеПоля.Добавить("Ссылка");
		Оператор.Отбор.Добавить(СтрШаблон("Ссылка В(&%1)", ИмяПараметра));
		
		Запрос.УстановитьПараметр(ИмяПараметра, Объекты.Значение);
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	ДопустимыеЗначения = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	// Ограничим исходную коллекцию только допустимыми значениями, через сокращение исходного массива чтобы сохранить
	// порядок элементов.
	НедопустимыеЗначения = ОбщегоНазначенияКлиентСервер.РазностьМассивов(МассивСсылок, ДопустимыеЗначения);
	МассивСсылок         = ОбщегоНазначенияКлиентСервер.РазностьМассивов(МассивСсылок, НедопустимыеЗначения);
	
КонецПроцедуры

// Определяет перечень организаций, чтение данных которых, размещенных в конкретном объекте метаданных,
// разрешено пользователю настройками прав доступа.
//
// Функцию можно использовать, если требуется получать данные в привилегированном режиме для предоставления их
// пользователю - она позволяет ограничить эти данные в соответствии с настройками.
//
// Функцию можно использовать только в тех случаях (для тех объектов),
// когда применяется стандартное ограничение доступа к запрашиваемому объекту метаданных - 
// то есть, аналогичное ограничению, применяемому для регистру бухгалтерии Хозрасчетный
// роли ДобавлениеИзменениеДанныхБухгалтерии.
//
// Порядок использования:
//  1. с помощью функции определяется список доступных организаций
//  2. в текстах запросов к самим данных (регистрам, документам) 
//     устанавливаются отборы по этим организациям
//  3. перед выполнением запроса к данным включается привилегированный режим.
//
// При использовании функции следует иметь в виду, что в общем случае ограничить выбираемые данные
// в соответствии с ОДД по Организации недостаточно:
// 1. в прикладном решении могут использоваться и иные виды доступа, не только Организации
// 2. перед установкой привилегированного режима в вызывающем коде следует проверить наличие прав
//    на чтение запрашиваемой таблицы (регистра, документов) в целом.
//
// Не следует (запрещается) вызывать эту функцию из кода, который может выполняться в привилегированном режиме,
// так как это приведет к последующей неверной ее работе вне привилегированного режима:
// может повторно использоваться значение, вычисленное в привилегированном режиме.
//
// Возвращаемое значение:
//  ФиксированныйМассив - содержит СправочникСсылка.Организации
//
// См. также ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS()
//
// Параметры:
//  ИмяОбъектаДанных - Строка - полное имя объекта данных, доступ к которым проверяется, например, "РегистрБухгалтерии.Хозрасчетный"
//  ПравоНаИзменение - Булево - Истина, если после выполнения запроса данные предполагается менять
//               и нужно проверить, что у пользователя есть право на изменение
//  Пользователь     - СправочникСсылка.Пользователи - Ссылка на пользователя, для которого нужно получить список организаций.
// 
Функция ОрганизацииДанныеКоторыхДоступныПользователю(ИмяОбъектаДанных, ПравоНаИзменение = Ложь, Пользователь = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей()
		Или Пользователи.ЭтоПолноправныйПользователь(Пользователь , , Ложь) Тогда
		
		// Ограничений по RLS нет, возвращаем все организации из справочника
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации";
		
	Иначе
	
		// Запрос взят из шаблона #ПоЗначениям роли ДобавлениеИзменениеДанныхБухгалтерии
		// с теми параметрами, с которыми он применяется для регистра бухгалтерии Хозрасчетный.
		Запрос.УстановитьПараметр("Пользователь", ?(Пользователь = Неопределено, Пользователи.ТекущийПользователь(), Пользователь));
		Запрос.УстановитьПараметр("Изменение", ПравоНаИзменение);
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				Справочник.ИдентификаторыОбъектовМетаданных КАК СвойстваТекущейТаблицы
		|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
		|					ПО
		|						СвойстваТекущейТаблицы.ПолноеИмя = &ИмяОбъектаДанных
		|							И ИСТИНА В
		|								(ВЫБРАТЬ ПЕРВЫЕ 1
		|									ИСТИНА
		|								ИЗ
		|									РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
		|								ГДЕ
		|									ТаблицыГруппДоступа.Таблица = СвойстваТекущейТаблицы.Ссылка
		|									И ТаблицыГруппДоступа.ГруппаДоступа = ГруппыДоступа.Ссылка
		|									И ТаблицыГруппДоступа.Изменение = &Изменение)
		|							И ГруппыДоступа.Ссылка В
		|								(ВЫБРАТЬ
		|									ГруппыДоступаПользователи.Ссылка КАК ГруппаДоступа
		|								ИЗ
		|									Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|										ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|										ПО
		|											СоставыГруппПользователей.Пользователь = &Пользователь
		|												И СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь)
		|			ГДЕ
		|				ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступа КАК Значения
		|									ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ГруппыЗначений
		|									ПО
		|										Значения.ГруппаДоступа = ГруппыДоступа.Ссылка
		|											И Значения.ЗначениеДоступа = Организации.Ссылка
		|											И ГруппыЗначений.ЗначениеДоступа = ГруппыЗначений.ГруппаЗначенийДоступа)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ = ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступаПоУмолчанию КАК ЗначенияПоУмолчанию
		|							ГДЕ
		|								ЗначенияПоУмолчанию.ГруппаДоступа = ГруппыДоступа.Ссылка
		|								И ТИПЗНАЧЕНИЯ(ЗначенияПоУмолчанию.ТипЗначенийДоступа) = ТИПЗНАЧЕНИЯ(Организации.Ссылка)
		|								И ЗначенияПоУмолчанию.ВсеРазрешены = ЛОЖЬ)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ)";
		
		Запрос.Текст = ?(ПравоНаИзменение,
			ТекстЗапроса,
			СтрЗаменить(ТекстЗапроса, "И ТаблицыГруппДоступа.Изменение = &Изменение", ""));
			
		Запрос.УстановитьПараметр("ИмяОбъектаДанных", ИмяОбъектаДанных);
			
	КонецЕсли;
	
	// Доступ к настройкам RLS выполняется в привилегированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Новый ФиксированныйМассив(МассивОрганизаций);
	
КонецФункции

#КонецОбласти